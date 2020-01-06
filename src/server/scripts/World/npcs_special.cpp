/*
 * Copyright (C) 2008-2019 TrinityCore <https://www.trinitycore.org/>
 * Copyright (C) 2006-2009 ScriptDev2 <https://scriptdev2.svn.sourceforge.net/>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "ScriptMgr.h"
#include "CellImpl.h"
#include "CombatAI.h"
#include "CreatureTextMgr.h"
#include "GameEventMgr.h"
#include "GridNotifiersImpl.h"
#include "Log.h"
#include "MotionMaster.h"
#include "MoveSplineInit.h"
#include "ObjectAccessor.h"
#include "ObjectMgr.h"
#include "PassiveAI.h"
#include "Pet.h"
#include "ScriptedEscortAI.h"
#include "ScriptedGossip.h"
#include "ScriptMgr.h"
#include "SmartAI.h"
#include "SpellAuras.h"
#include "SpellHistory.h"
#include "SpellMgr.h"
#include "World.h"

/*########
# npc_air_force_bots
#########*/

enum AirForceBots
{
    TRIPWIRE, // do not attack flying players, smaller range
    ALARMBOT, // attack flying players, casts guard's mark

    SPELL_GUARDS_MARK = 38067
};

float constexpr RANGE_TRIPWIRE =  15.0f;
float constexpr RANGE_ALARMBOT = 100.0f;

struct AirForceSpawn
{
    uint32 myEntry;
    uint32 otherEntry;
    AirForceBots type;
};

AirForceSpawn constexpr airforceSpawns[] =
{
    {2614,  15241, ALARMBOT}, // Air Force Alarm Bot (Alliance)
    {2615,  15242, ALARMBOT}, // Air Force Alarm Bot (Horde)
    {21974, 21976, ALARMBOT}, // Air Force Alarm Bot (Area 52)
    {21993, 15242, ALARMBOT}, // Air Force Guard Post (Horde - Bat Rider)
    {21996, 15241, ALARMBOT}, // Air Force Guard Post (Alliance - Gryphon)
    {21997, 21976, ALARMBOT}, // Air Force Guard Post (Goblin - Area 52 - Zeppelin)
    {21999, 15241, TRIPWIRE}, // Air Force Trip Wire - Rooftop (Alliance)
    {22001, 15242, TRIPWIRE}, // Air Force Trip Wire - Rooftop (Horde)
    {22002, 15242, TRIPWIRE}, // Air Force Trip Wire - Ground (Horde)
    {22003, 15241, TRIPWIRE}, // Air Force Trip Wire - Ground (Alliance)
    {22063, 21976, TRIPWIRE}, // Air Force Trip Wire - Rooftop (Goblin - Area 52)
    {22065, 22064, ALARMBOT}, // Air Force Guard Post (Ethereal - Stormspire)
    {22066, 22067, ALARMBOT}, // Air Force Guard Post (Scryer - Dragonhawk)
    {22068, 22064, TRIPWIRE}, // Air Force Trip Wire - Rooftop (Ethereal - Stormspire)
    {22069, 22064, ALARMBOT}, // Air Force Alarm Bot (Stormspire)
    {22070, 22067, TRIPWIRE}, // Air Force Trip Wire - Rooftop (Scryer)
    {22071, 22067, ALARMBOT}, // Air Force Alarm Bot (Scryer)
    {22078, 22077, ALARMBOT}, // Air Force Alarm Bot (Aldor)
    {22079, 22077, ALARMBOT}, // Air Force Guard Post (Aldor - Gryphon)
    {22080, 22077, TRIPWIRE}, // Air Force Trip Wire - Rooftop (Aldor)
    {22086, 22085, ALARMBOT}, // Air Force Alarm Bot (Sporeggar)
    {22087, 22085, ALARMBOT}, // Air Force Guard Post (Sporeggar - Spore Bat)
    {22088, 22085, TRIPWIRE}, // Air Force Trip Wire - Rooftop (Sporeggar)
    {22090, 22089, ALARMBOT}, // Air Force Guard Post (Toshley's Station - Flying Machine)
    {22124, 22122, ALARMBOT}, // Air Force Alarm Bot (Cenarion)
    {22125, 22122, ALARMBOT}, // Air Force Guard Post (Cenarion - Stormcrow)
    {22126, 22122, ALARMBOT}  // Air Force Trip Wire - Rooftop (Cenarion Expedition)
};

class npc_air_force_bots : public CreatureScript
{
public:
    npc_air_force_bots() : CreatureScript("npc_air_force_bots") { }

    struct npc_air_force_botsAI : public NullCreatureAI
    {
        static AirForceSpawn const& FindSpawnFor(uint32 entry)
        {
            for (AirForceSpawn const& spawn : airforceSpawns)
            {
                if (spawn.myEntry == entry)
                {
                    ASSERT_NODEBUGINFO(sObjectMgr->GetCreatureTemplate(spawn.otherEntry), "Invalid creature entry %u in 'npc_air_force_bots' script", spawn.otherEntry);
                    return spawn;
                }
            }
            ASSERT_NODEBUGINFO(false, "Unhandled creature with entry %u is assigned 'npc_air_force_bots' script", entry);
        }

        npc_air_force_botsAI(Creature* creature) : NullCreatureAI(creature), _spawn(FindSpawnFor(creature->GetEntry())) {}

        Creature* GetOrSummonGuard()
        {
            Creature* guard = ObjectAccessor::GetCreature(*me, _myGuard);

            if (!guard && (guard = me->SummonCreature(_spawn.otherEntry, 0.0f, 0.0f, 0.0f, 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 300000)))
                _myGuard = guard->GetGUID();

            return guard;
        }

        void UpdateAI(uint32 /*diff*/) override
        {
            if (_toAttack.empty())
                return;

            Creature* guard = GetOrSummonGuard();
            if (!guard)
                return;

            for (ObjectGuid guid : _toAttack)
            {
                Unit* target = ObjectAccessor::GetUnit(*me, guid);
                if (!target)
                    continue;
                if (guard->IsEngagedBy(target))
                    continue;

                guard->EngageWithTarget(target);
                if (_spawn.type == ALARMBOT)
                    guard->CastSpell(target, SPELL_GUARDS_MARK, true);
            }

            _toAttack.clear();
        }

        void MoveInLineOfSight(Unit* who) override
        {
            // guards are only spawned against players
            if (who->GetTypeId() != TYPEID_PLAYER)
                return;

            // we're already scheduled to attack this player on our next tick, don't bother checking
            if (_toAttack.find(who->GetGUID()) != _toAttack.end())
                return;

            // check if they're in range
            if (!who->IsWithinDistInMap(me, (_spawn.type == ALARMBOT) ? RANGE_ALARMBOT : RANGE_TRIPWIRE))
                return;

            // check if they're hostile
            if (!(me->IsHostileTo(who) || who->IsHostileTo(me)))
                return;

            // check if they're a valid attack target
            if (!me->IsValidAttackTarget(who))
                return;

            if ((_spawn.type == TRIPWIRE) && who->IsFlying())
                return;

            _toAttack.insert(who->GetGUID());
        }

        private:
            AirForceSpawn const& _spawn;
            ObjectGuid _myGuard;
            std::unordered_set<ObjectGuid> _toAttack;
            
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_air_force_botsAI(creature);
    }
};

/*########
# npc_chicken_cluck
#########*/

enum ChickenCluck
{
    EMOTE_HELLO_A       = 0,
    EMOTE_HELLO_H       = 1,
    EMOTE_CLUCK_TEXT    = 2,

    QUEST_CLUCK         = 3861
};

class npc_chicken_cluck : public CreatureScript
{
public:
    npc_chicken_cluck() : CreatureScript("npc_chicken_cluck") { }

    struct npc_chicken_cluckAI : public ScriptedAI
    {
        npc_chicken_cluckAI(Creature* creature) : ScriptedAI(creature)
        {
            Initialize();
        }

        void Initialize()
        {
            ResetFlagTimer = 120000;
        }

        uint32 ResetFlagTimer;

        void Reset() override
        {
            Initialize();
            me->SetFaction(FACTION_PREY);
            me->RemoveFlag(UNIT_NPC_FLAGS, UNIT_NPC_FLAG_QUESTGIVER);
        }

        void JustEngagedWith(Unit* /*who*/) override { }

        void UpdateAI(uint32 diff) override
        {
            // Reset flags after a certain time has passed so that the next player has to start the 'event' again
            if (me->HasFlag(UNIT_NPC_FLAGS, UNIT_NPC_FLAG_QUESTGIVER))
            {
                if (ResetFlagTimer <= diff)
                {
                    EnterEvadeMode();
                    return;
                }
                else
                    ResetFlagTimer -= diff;
            }

            if (UpdateVictim())
                DoMeleeAttackIfReady();
        }

        void ReceiveEmote(Player* player, uint32 emote) override
        {
            switch (emote)
            {
                case TEXTEMOTE_CHICKEN:
                    if (player->GetQuestStatus(QUEST_CLUCK) == QUEST_STATUS_NONE && rand32() % 30 == 1)
                    {
                        me->SetFlag(UNIT_NPC_FLAGS, UNIT_NPC_FLAG_QUESTGIVER);
                        me->SetFaction(FACTION_FRIENDLY);
                        Talk(player->GetTeam() == HORDE ? EMOTE_HELLO_H : EMOTE_HELLO_A);
                    }
                    break;
                case TEXTEMOTE_CHEER:
                    if (player->GetQuestStatus(QUEST_CLUCK) == QUEST_STATUS_COMPLETE)
                    {
                        me->SetFlag(UNIT_NPC_FLAGS, UNIT_NPC_FLAG_QUESTGIVER);
                        me->SetFaction(FACTION_FRIENDLY);
                        Talk(EMOTE_CLUCK_TEXT);
                    }
                    break;
            }
        }

        void QuestAccept(Player* /*player*/, Quest const* quest) override
        {
            if (quest->GetQuestId() == QUEST_CLUCK)
                Reset();
        }

        void QuestReward(Player* /*player*/, Quest const* quest, uint32 /*opt*/) override
        {
            if (quest->GetQuestId() == QUEST_CLUCK)
                Reset();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_chicken_cluckAI(creature);
    }
};

/*######
## npc_dancing_flames
######*/

enum DancingFlames
{
    SPELL_BRAZIER           = 45423,
    SPELL_SEDUCTION         = 47057,
    SPELL_FIERY_AURA        = 45427
};

class npc_dancing_flames : public CreatureScript
{
public:
    npc_dancing_flames() : CreatureScript("npc_dancing_flames") { }

    struct npc_dancing_flamesAI : public ScriptedAI
    {
        npc_dancing_flamesAI(Creature* creature) : ScriptedAI(creature)
        {
            Initialize();
        }

        void Initialize()
        {
            Active = true;
            CanIteract = 3500;
        }

        bool Active;
        uint32 CanIteract;

        void Reset() override
        {
            Initialize();
            DoCast(me, SPELL_BRAZIER, true);
            DoCast(me, SPELL_FIERY_AURA, false);
            float x, y, z;
            me->GetPosition(x, y, z);
            me->Relocate(x, y, z + 0.94f);
            me->SetDisableGravity(true);
            me->HandleEmoteCommand(EMOTE_ONESHOT_DANCE);
            WorldPacket data;                       //send update position to client
            me->BuildHeartBeatMsg(&data);
            me->SendMessageToSet(&data, true);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!Active)
            {
                if (CanIteract <= diff)
                {
                    Active = true;
                    CanIteract = 3500;
                    me->HandleEmoteCommand(EMOTE_ONESHOT_DANCE);
                }
                else
                    CanIteract -= diff;
            }
        }

        void JustEngagedWith(Unit* /*who*/) override { }

        void ReceiveEmote(Player* player, uint32 emote) override
        {
            if (me->IsWithinLOS(player->GetPositionX(), player->GetPositionY(), player->GetPositionZ()) && me->IsWithinDistInMap(player, 30.0f))
            {
                me->SetFacingToObject(player);
                Active = false;

                WorldPacket data;
                me->BuildHeartBeatMsg(&data);
                me->SendMessageToSet(&data, true);
                switch (emote)
                {
                    case TEXTEMOTE_KISS:
                        me->HandleEmoteCommand(EMOTE_ONESHOT_SHY);
                        break;
                    case TEXTEMOTE_WAVE:
                        me->HandleEmoteCommand(EMOTE_ONESHOT_WAVE);
                        break;
                    case TEXTEMOTE_BOW:
                        me->HandleEmoteCommand(EMOTE_ONESHOT_BOW);
                        break;
                    case TEXTEMOTE_JOKE:
                        me->HandleEmoteCommand(EMOTE_ONESHOT_LAUGH);
                        break;
                    case TEXTEMOTE_DANCE:
                        if (!player->HasAura(SPELL_SEDUCTION))
                            DoCast(player, SPELL_SEDUCTION, true);
                        break;
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_dancing_flamesAI(creature);
    }
};

/*######
## npc_torch_tossing_target_bunny_controller
######*/

enum TorchTossingTarget
{
    SPELL_TORCH_TARGET_PICKER      = 45907
};

class npc_torch_tossing_target_bunny_controller : public CreatureScript
{
public:
    npc_torch_tossing_target_bunny_controller() : CreatureScript("npc_torch_tossing_target_bunny_controller") { }

    struct npc_torch_tossing_target_bunny_controllerAI : public ScriptedAI
    {
        npc_torch_tossing_target_bunny_controllerAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            _scheduler.Schedule(Seconds(2), [this](TaskContext context)
            {
                me->CastSpell(nullptr, SPELL_TORCH_TARGET_PICKER);
                _scheduler.Schedule(Seconds(3), [this](TaskContext /*context*/)
                {
                    me->CastSpell(nullptr, SPELL_TORCH_TARGET_PICKER);
                });
                context.Repeat(Seconds(5));
            });
        }

        void UpdateAI(uint32 diff) override
        {
            _scheduler.Update(diff);
        }

    private:
        TaskScheduler _scheduler;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_torch_tossing_target_bunny_controllerAI(creature);
    }
};

/*######
## npc_midsummer_bunny_pole
######*/

enum RibbonPoleData
{
    GO_RIBBON_POLE              = 181605,
    SPELL_RIBBON_DANCE_COSMETIC = 29726,
    SPELL_RED_FIRE_RING         = 46836,
    SPELL_BLUE_FIRE_RING        = 46842,
    EVENT_CAST_RED_FIRE_RING    = 1,
    EVENT_CAST_BLUE_FIRE_RING   = 2
};

class npc_midsummer_bunny_pole : public CreatureScript
{
public:
    npc_midsummer_bunny_pole() : CreatureScript("npc_midsummer_bunny_pole") { }

    struct npc_midsummer_bunny_poleAI : public ScriptedAI
    {
        npc_midsummer_bunny_poleAI(Creature* creature) : ScriptedAI(creature)
        {
            Initialize();
        }

        void Initialize()
        {
            events.Reset();
            running = false;
        }

        void Reset() override
        {
            Initialize();
        }

        void DoAction(int32 /*action*/) override
        {
            // Don't start event if it's already running.
            if (running)
                return;

            running = true;
            events.ScheduleEvent(EVENT_CAST_RED_FIRE_RING, 1);
        }

        bool checkNearbyPlayers()
        {
            // Returns true if no nearby player has aura "Test Ribbon Pole Channel".
            std::list<Player*> players;
            Trinity::UnitAuraCheck check(true, SPELL_RIBBON_DANCE_COSMETIC);
            Trinity::PlayerListSearcher<Trinity::UnitAuraCheck> searcher(me, players, check);
            Cell::VisitWorldObjects(me, searcher, 10.0f);

            return players.empty();
        }

        void UpdateAI(uint32 diff) override
        {
            if (!running)
                return;

            events.Update(diff);

            switch (events.ExecuteEvent())
            {
            case EVENT_CAST_RED_FIRE_RING:
            {
                if (checkNearbyPlayers())
                {
                    Reset();
                    return;
                }

                if (GameObject* go = me->FindNearestGameObject(GO_RIBBON_POLE, 10.0f))
                    me->CastSpell(go, SPELL_RED_FIRE_RING, true);

                events.ScheduleEvent(EVENT_CAST_BLUE_FIRE_RING, 5s);
            }
            break;
            case EVENT_CAST_BLUE_FIRE_RING:
            {
                if (checkNearbyPlayers())
                {
                    Reset();
                    return;
                }

                if (GameObject* go = me->FindNearestGameObject(GO_RIBBON_POLE, 10.0f))
                    me->CastSpell(go, SPELL_BLUE_FIRE_RING, true);

                events.ScheduleEvent(EVENT_CAST_RED_FIRE_RING, 5s);
            }
            break;
            }
        }

    private:
        EventMap events;
        bool running;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_midsummer_bunny_poleAI(creature);
    }
};

/*######
## Triage quest
######*/

enum Doctor
{
    SAY_DOC             = 0,

    DOCTOR_ALLIANCE     = 12939,
    DOCTOR_HORDE        = 12920,
    ALLIANCE_COORDS     = 7,
    HORDE_COORDS        = 6
};

Position const AllianceCoords[]=
{
    {-3757.38f, -4533.05f, 14.16f, 3.62f},                      // Top-far-right bunk as seen from entrance
    {-3754.36f, -4539.13f, 14.16f, 5.13f},                      // Top-far-left bunk
    {-3749.54f, -4540.25f, 14.28f, 3.34f},                      // Far-right bunk
    {-3742.10f, -4536.85f, 14.28f, 3.64f},                      // Right bunk near entrance
    {-3755.89f, -4529.07f, 14.05f, 0.57f},                      // Far-left bunk
    {-3749.51f, -4527.08f, 14.07f, 5.26f},                      // Mid-left bunk
    {-3746.37f, -4525.35f, 14.16f, 5.22f},                      // Left bunk near entrance
};

//alliance run to where
#define A_RUNTOX -3742.96f
#define A_RUNTOY -4531.52f
#define A_RUNTOZ 11.91f

Position const HordeCoords[]=
{
    {-1013.75f, -3492.59f, 62.62f, 4.34f},                      // Left, Behind
    {-1017.72f, -3490.92f, 62.62f, 4.34f},                      // Right, Behind
    {-1015.77f, -3497.15f, 62.82f, 4.34f},                      // Left, Mid
    {-1019.51f, -3495.49f, 62.82f, 4.34f},                      // Right, Mid
    {-1017.25f, -3500.85f, 62.98f, 4.34f},                      // Left, front
    {-1020.95f, -3499.21f, 62.98f, 4.34f}                       // Right, Front
};

//horde run to where
#define H_RUNTOX -1016.44f
#define H_RUNTOY -3508.48f
#define H_RUNTOZ 62.96f

uint32 const AllianceSoldierId[3] =
{
    12938,                                                  // 12938 Injured Alliance Soldier
    12936,                                                  // 12936 Badly injured Alliance Soldier
    12937                                                   // 12937 Critically injured Alliance Soldier
};

uint32 const HordeSoldierId[3] =
{
    12923,                                                  //12923 Injured Soldier
    12924,                                                  //12924 Badly injured Soldier
    12925                                                   //12925 Critically injured Soldier
};

/*######
## npc_doctor (handles both Gustaf Vanhowzen and Gregory Victor)
######*/
class npc_doctor : public CreatureScript
{
public:
    npc_doctor() : CreatureScript("npc_doctor") { }

    struct npc_doctorAI : public ScriptedAI
    {
        npc_doctorAI(Creature* creature) : ScriptedAI(creature)
        {
            Initialize();
        }

        void Initialize()
        {
            PlayerGUID.Clear();

            SummonPatientTimer = 10000;
            SummonPatientCount = 0;
            PatientDiedCount = 0;
            PatientSavedCount = 0;

            Patients.clear();
            Coordinates.clear();

            Event = false;
        }

        ObjectGuid PlayerGUID;

        uint32 SummonPatientTimer;
        uint32 SummonPatientCount;
        uint32 PatientDiedCount;
        uint32 PatientSavedCount;

        bool Event;

        GuidList Patients;
        std::vector<Position const*> Coordinates;

        void Reset() override
        {
            Initialize();
            me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
        }

        void BeginEvent(Player* player)
        {
            PlayerGUID = player->GetGUID();

            SummonPatientTimer = 10000;
            SummonPatientCount = 0;
            PatientDiedCount = 0;
            PatientSavedCount = 0;

            switch (me->GetEntry())
            {
                case DOCTOR_ALLIANCE:
                    for (uint8 i = 0; i < ALLIANCE_COORDS; ++i)
                        Coordinates.push_back(&AllianceCoords[i]);
                    break;
                case DOCTOR_HORDE:
                    for (uint8 i = 0; i < HORDE_COORDS; ++i)
                        Coordinates.push_back(&HordeCoords[i]);
                    break;
            }

            Event = true;
            me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
        }

        void PatientDied(Position const* point)
        {
            Player* player = ObjectAccessor::GetPlayer(*me, PlayerGUID);
            if (player && ((player->GetQuestStatus(6624) == QUEST_STATUS_INCOMPLETE) || (player->GetQuestStatus(6622) == QUEST_STATUS_INCOMPLETE)))
            {
                ++PatientDiedCount;

                if (PatientDiedCount > 5 && Event)
                {
                    if (player->GetQuestStatus(6624) == QUEST_STATUS_INCOMPLETE)
                        player->FailQuest(6624);
                    else if (player->GetQuestStatus(6622) == QUEST_STATUS_INCOMPLETE)
                        player->FailQuest(6622);

                    Reset();
                    return;
                }

                Coordinates.push_back(point);
            }
            else
                // If no player or player abandon quest in progress
                Reset();
        }

        void PatientSaved(Creature* /*soldier*/, Player* player, Position const* point)
        {
            if (player && PlayerGUID == player->GetGUID())
            {
                if ((player->GetQuestStatus(6624) == QUEST_STATUS_INCOMPLETE) || (player->GetQuestStatus(6622) == QUEST_STATUS_INCOMPLETE))
                {
                    ++PatientSavedCount;

                    if (PatientSavedCount == 15)
                    {
                        if (!Patients.empty())
                        {
                            for (GuidList::const_iterator itr = Patients.begin(); itr != Patients.end(); ++itr)
                            {
                                if (Creature* patient = ObjectAccessor::GetCreature(*me, *itr))
                                    patient->SetDeathState(JUST_DIED);
                            }
                        }

                        if (player->GetQuestStatus(6624) == QUEST_STATUS_INCOMPLETE)
                            player->AreaExploredOrEventHappens(6624);
                        else if (player->GetQuestStatus(6622) == QUEST_STATUS_INCOMPLETE)
                            player->AreaExploredOrEventHappens(6622);

                        Reset();
                        return;
                    }

                    Coordinates.push_back(point);
                }
            }
        }

        void UpdateAI(uint32 diff) override;

        void JustEngagedWith(Unit* /*who*/) override { }

        void QuestAccept(Player* player, Quest const* quest) override
        {
            if ((quest->GetQuestId() == 6624) || (quest->GetQuestId() == 6622))
                BeginEvent(player);
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_doctorAI(creature);
    }
};

/*#####
## npc_injured_patient (handles all the patients, no matter Horde or Alliance)
#####*/

class npc_injured_patient : public CreatureScript
{
public:
    npc_injured_patient() : CreatureScript("npc_injured_patient") { }

    struct npc_injured_patientAI : public ScriptedAI
    {
        npc_injured_patientAI(Creature* creature) : ScriptedAI(creature)
        {
            Initialize();
        }

        void Initialize()
        {
            DoctorGUID.Clear();
            Coord = nullptr;
        }

        ObjectGuid DoctorGUID;
        Position const* Coord;

        void Reset() override
        {
            Initialize();

            //no select
            me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);

            //no regen health
            me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IN_COMBAT);

            //to make them lay with face down
            me->SetUInt32Value(UNIT_FIELD_BYTES_1, UNIT_STAND_STATE_DEAD);

            uint32 mobId = me->GetEntry();

            switch (mobId)
            {                                                   //lower max health
                case 12923:
                case 12938:                                     //Injured Soldier
                    me->SetHealth(me->CountPctFromMaxHealth(75));
                    break;
                case 12924:
                case 12936:                                     //Badly injured Soldier
                    me->SetHealth(me->CountPctFromMaxHealth(50));
                    break;
                case 12925:
                case 12937:                                     //Critically injured Soldier
                    me->SetHealth(me->CountPctFromMaxHealth(25));
                    break;
            }
        }

        void JustEngagedWith(Unit* /*who*/) override { }

        void SpellHit(Unit* caster, SpellInfo const* spell) override
        {
            Player* player = caster->ToPlayer();
            if (!player || !me->IsAlive() || spell->Id != 20804)
                return;

            if (player->GetQuestStatus(6624) == QUEST_STATUS_INCOMPLETE || player->GetQuestStatus(6622) == QUEST_STATUS_INCOMPLETE)
                if (DoctorGUID)
                    if (Creature* doctor = ObjectAccessor::GetCreature(*me, DoctorGUID))
                        ENSURE_AI(npc_doctor::npc_doctorAI, doctor->AI())->PatientSaved(me, player, Coord);

            //make not selectable
            me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);

            //regen health
            me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IN_COMBAT);

            //stand up
            me->SetUInt32Value(UNIT_FIELD_BYTES_1, UNIT_STAND_STATE_STAND);

            Talk(SAY_DOC);

            uint32 mobId = me->GetEntry();
            me->SetWalk(false);

            switch (mobId)
            {
                case 12923:
                case 12924:
                case 12925:
                    me->GetMotionMaster()->MovePoint(0, H_RUNTOX, H_RUNTOY, H_RUNTOZ);
                    break;
                case 12936:
                case 12937:
                case 12938:
                    me->GetMotionMaster()->MovePoint(0, A_RUNTOX, A_RUNTOY, A_RUNTOZ);
                    break;
            }
        }

        void UpdateAI(uint32 /*diff*/) override
        {
            //lower HP on every world tick makes it a useful counter, not officlone though
            if (me->IsAlive() && me->GetHealth() > 6)
                me->ModifyHealth(-5);

            if (me->IsAlive() && me->GetHealth() <= 6)
            {
                me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IN_COMBAT);
                me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                me->SetDeathState(JUST_DIED);
                me->SetFlag(UNIT_DYNAMIC_FLAGS, 32);

                if (DoctorGUID)
                    if (Creature* doctor = ObjectAccessor::GetCreature((*me), DoctorGUID))
                        ENSURE_AI(npc_doctor::npc_doctorAI, doctor->AI())->PatientDied(Coord);
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_injured_patientAI(creature);
    }
};

void npc_doctor::npc_doctorAI::UpdateAI(uint32 diff)
{
    if (Event && SummonPatientCount >= 20)
    {
        Reset();
        return;
    }

    if (Event)
    {
        if (SummonPatientTimer <= diff)
        {
            if (Coordinates.empty())
                return;

            uint32 patientEntry = 0;

            switch (me->GetEntry())
            {
                case DOCTOR_ALLIANCE:
                    patientEntry = AllianceSoldierId[rand32() % 3];
                    break;
                case DOCTOR_HORDE:
                    patientEntry = HordeSoldierId[rand32() % 3];
                    break;
                default:
                    TC_LOG_ERROR("scripts", "Invalid entry for Triage doctor. Please check your database");
                    return;
            }

            std::vector<Position const*>::iterator point = Coordinates.begin();
            std::advance(point, urand(0, Coordinates.size() - 1));

            if (Creature* Patient = me->SummonCreature(patientEntry, **point, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 5000))
            {
                //303, this flag appear to be required for client side item->spell to work (TARGET_SINGLE_FRIEND)
                Patient->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PLAYER_CONTROLLED);

                Patients.push_back(Patient->GetGUID());
                ENSURE_AI(npc_injured_patient::npc_injured_patientAI, Patient->AI())->DoctorGUID = me->GetGUID();
                ENSURE_AI(npc_injured_patient::npc_injured_patientAI, Patient->AI())->Coord = *point;

                Coordinates.erase(point);
            }

            SummonPatientTimer = 10000;
            ++SummonPatientCount;
        }
        else
            SummonPatientTimer -= diff;
    }
}

/*######
## npc_garments_of_quests
######*/

/// @todo get text for each NPC

enum Garments
{
    SPELL_LESSER_HEAL_R2    = 2052,
    SPELL_FORTITUDE_R1      = 1243,

    QUEST_MOON              = 5621,
    QUEST_LIGHT_1           = 5624,
    QUEST_LIGHT_2           = 5625,
    QUEST_SPIRIT            = 5648,
    QUEST_DARKNESS          = 5650,

    ENTRY_SHAYA             = 12429,
    ENTRY_ROBERTS           = 12423,
    ENTRY_DOLF              = 12427,
    ENTRY_KORJA             = 12430,
    ENTRY_DG_KEL            = 12428,

    // used by 12429, 12423, 12427, 12430, 12428, but signed for 12429
    SAY_THANKS              = 0,
    SAY_GOODBYE             = 1,
    SAY_HEALED              = 2,
};

class npc_garments_of_quests : public CreatureScript
{
public:
    npc_garments_of_quests() : CreatureScript("npc_garments_of_quests") { }

    struct npc_garments_of_questsAI : public EscortAI
    {
        npc_garments_of_questsAI(Creature* creature) : EscortAI(creature)
        {
            switch (me->GetEntry())
            {
                case ENTRY_SHAYA:
                    quest = QUEST_MOON;
                    break;
                case ENTRY_ROBERTS:
                    quest = QUEST_LIGHT_1;
                    break;
                case ENTRY_DOLF:
                    quest = QUEST_LIGHT_2;
                    break;
                case ENTRY_KORJA:
                    quest = QUEST_SPIRIT;
                    break;
                case ENTRY_DG_KEL:
                    quest = QUEST_DARKNESS;
                    break;
                default:
                    quest = 0;
                    break;
            }

            Reset();
        }

        ObjectGuid CasterGUID;

        bool IsHealed;
        bool CanRun;

        uint32 RunAwayTimer;
        uint32 quest;

        void Reset() override
        {
            CasterGUID.Clear();

            IsHealed = false;
            CanRun = false;

            RunAwayTimer = 5000;

            me->SetStandState(UNIT_STAND_STATE_KNEEL);
            // expect database to have RegenHealth=0
            me->SetHealth(me->CountPctFromMaxHealth(70));
        }

        void JustEngagedWith(Unit* /*who*/) override { }

        void SpellHit(Unit* caster, SpellInfo const* spell) override
        {
            if (spell->Id == SPELL_LESSER_HEAL_R2 || spell->Id == SPELL_FORTITUDE_R1)
            {
                //not while in combat
                if (me->IsInCombat())
                    return;

                //nothing to be done now
                if (IsHealed && CanRun)
                    return;

                if (Player* player = caster->ToPlayer())
                {
                    if (quest && player->GetQuestStatus(quest) == QUEST_STATUS_INCOMPLETE)
                    {
                        if (IsHealed && !CanRun && spell->Id == SPELL_FORTITUDE_R1)
                        {
                            Talk(SAY_THANKS, caster);
                            CanRun = true;
                        }
                        else if (!IsHealed && spell->Id == SPELL_LESSER_HEAL_R2)
                        {
                            CasterGUID = caster->GetGUID();
                            me->SetStandState(UNIT_STAND_STATE_STAND);
                            Talk(SAY_HEALED, caster);
                            IsHealed = true;
                        }
                    }

                    // give quest credit, not expect any special quest objectives
                    if (CanRun)
                        player->TalkedToCreature(me->GetEntry(), me->GetGUID());
                }
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (CanRun && !me->IsInCombat())
            {
                if (RunAwayTimer <= diff)
                {
                    if (Unit* unit = ObjectAccessor::GetUnit(*me, CasterGUID))
                    {
                        switch (me->GetEntry())
                        {
                            case ENTRY_SHAYA:
                            case ENTRY_ROBERTS:
                            case ENTRY_DOLF:
                            case ENTRY_KORJA:
                            case ENTRY_DG_KEL:
                                Talk(SAY_GOODBYE, unit);
                                break;
                        }

                        Start(false, true);
                    }
                    else
                        EnterEvadeMode();                       //something went wrong

                    RunAwayTimer = 30000;
                }
                else
                    RunAwayTimer -= diff;
            }

            EscortAI::UpdateAI(diff);
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_garments_of_questsAI(creature);
    }
};

/*######
## npc_guardian
######*/

enum GuardianSpells
{
    SPELL_DEATHTOUCH            = 5
};

class npc_guardian : public CreatureScript
{
public:
    npc_guardian() : CreatureScript("npc_guardian") { }

    struct npc_guardianAI : public ScriptedAI
    {
        npc_guardianAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
        }

        void UpdateAI(uint32 /*diff*/) override
        {
            if (!UpdateVictim())
                return;

            if (me->IsAttackReady())
            {
                DoCastVictim(SPELL_DEATHTOUCH, true);
                me->ResetAttackTimer();
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_guardianAI(creature);
    }
};

/*######
## npc_sayge
######*/

enum Sayge
{
    GOSSIP_MENU_OPTION_ID_ANSWER_1   = 0,
    GOSSIP_MENU_OPTION_ID_ANSWER_2   = 1,
    GOSSIP_MENU_OPTION_ID_ANSWER_3   = 2,
    GOSSIP_MENU_OPTION_ID_ANSWER_4   = 3,
    GOSSIP_I_AM_READY_TO_DISCOVER    = 6186,
    GOSSIP_MENU_OPTION_SAYGE1        = 6185,
    GOSSIP_MENU_OPTION_SAYGE2        = 6185,
    GOSSIP_MENU_OPTION_SAYGE3        = 6185,
    GOSSIP_MENU_OPTION_SAYGE4        = 6185,
    GOSSIP_MENU_OPTION_SAYGE5        = 6187,
    GOSSIP_MENU_OPTION_SAYGE6        = 6187,
    GOSSIP_MENU_OPTION_SAYGE7        = 6187,
    GOSSIP_MENU_OPTION_SAYGE8        = 6208,
    GOSSIP_MENU_OPTION_SAYGE9        = 6208,
    GOSSIP_MENU_OPTION_SAYGE10       = 6208,
    GOSSIP_MENU_OPTION_SAYGE11       = 6209,
    GOSSIP_MENU_OPTION_SAYGE12       = 6209,
    GOSSIP_MENU_OPTION_SAYGE13       = 6209,
    GOSSIP_MENU_OPTION_SAYGE14       = 6210,
    GOSSIP_MENU_OPTION_SAYGE15       = 6210,
    GOSSIP_MENU_OPTION_SAYGE16       = 6210,
    GOSSIP_MENU_OPTION_SAYGE17       = 6211,
    GOSSIP_MENU_I_HAVE_LONG_KNOWN    = 7339,
    GOSSIP_MENU_YOU_HAVE_BEEN_TASKED = 7340,
    GOSSIP_MENU_SWORN_EXECUTIONER    = 7341,
    GOSSIP_MENU_DIPLOMATIC_MISSION   = 7361,
    GOSSIP_MENU_YOUR_BROTHER_SEEKS   = 7362,
    GOSSIP_MENU_A_TERRIBLE_BEAST     = 7363,
    GOSSIP_MENU_YOUR_FORTUNE_IS_CAST = 7364,
    GOSSIP_MENU_HERE_IS_YOUR_FORTUNE = 7365,
    GOSSIP_MENU_CANT_GIVE_YOU_YOUR   = 7393,

    SPELL_STRENGTH                   = 23735, // +10% Strength
    SPELL_AGILITY                    = 23736, // +10% Agility
    SPELL_STAMINA                    = 23737, // +10% Stamina
    SPELL_SPIRIT                     = 23738, // +10% Spirit
    SPELL_INTELLECT                  = 23766, // +10% Intellect
    SPELL_ARMOR                      = 23767, // +10% Armor
    SPELL_DAMAGE                     = 23768, // +10% Damage
    SPELL_RESISTANCE                 = 23769, // +25 Magic Resistance (All)
    SPELL_FORTUNE                    = 23765  // Darkmoon Faire Fortune
};

class npc_sayge : public CreatureScript
{
public:
    npc_sayge() : CreatureScript("npc_sayge") { }

    struct npc_saygeAI : public ScriptedAI
    {
        npc_saygeAI(Creature* creature) : ScriptedAI(creature) { }

        bool GossipHello(Player* player) override
        {
            if (me->IsQuestGiver())
                player->PrepareQuestMenu(me->GetGUID());

            if (player->GetSpellHistory()->HasCooldown(SPELL_STRENGTH) ||
                player->GetSpellHistory()->HasCooldown(SPELL_AGILITY) ||
                player->GetSpellHistory()->HasCooldown(SPELL_STAMINA) ||
                player->GetSpellHistory()->HasCooldown(SPELL_SPIRIT) ||
                player->GetSpellHistory()->HasCooldown(SPELL_INTELLECT) ||
                player->GetSpellHistory()->HasCooldown(SPELL_ARMOR) ||
                player->GetSpellHistory()->HasCooldown(SPELL_DAMAGE) ||
                player->GetSpellHistory()->HasCooldown(SPELL_RESISTANCE))
                SendGossipMenuFor(player, GOSSIP_MENU_CANT_GIVE_YOU_YOUR, me->GetGUID());
            else
            {
                AddGossipItemFor(player, GOSSIP_I_AM_READY_TO_DISCOVER, GOSSIP_MENU_OPTION_ID_ANSWER_1, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);
                SendGossipMenuFor(player, GOSSIP_MENU_I_HAVE_LONG_KNOWN, me->GetGUID());
            }

            return true;
        }

        void SendAction(Player* player, uint32 action)
        {
            switch (action)
            {
                case GOSSIP_ACTION_INFO_DEF + 1:
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE1, GOSSIP_MENU_OPTION_ID_ANSWER_1, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE2, GOSSIP_MENU_OPTION_ID_ANSWER_2, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE3, GOSSIP_MENU_OPTION_ID_ANSWER_3, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 4);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE4, GOSSIP_MENU_OPTION_ID_ANSWER_4, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 5);
                    SendGossipMenuFor(player, GOSSIP_MENU_YOU_HAVE_BEEN_TASKED, me->GetGUID());
                    break;
                case GOSSIP_ACTION_INFO_DEF + 2:
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE5, GOSSIP_MENU_OPTION_ID_ANSWER_1, GOSSIP_SENDER_MAIN + 1, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE6, GOSSIP_MENU_OPTION_ID_ANSWER_2, GOSSIP_SENDER_MAIN + 2, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE7, GOSSIP_MENU_OPTION_ID_ANSWER_3, GOSSIP_SENDER_MAIN + 3, GOSSIP_ACTION_INFO_DEF);
                    SendGossipMenuFor(player, GOSSIP_MENU_SWORN_EXECUTIONER, me->GetGUID());
                    break;
                case GOSSIP_ACTION_INFO_DEF + 3:
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE8, GOSSIP_MENU_OPTION_ID_ANSWER_1, GOSSIP_SENDER_MAIN + 4, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE9, GOSSIP_MENU_OPTION_ID_ANSWER_2, GOSSIP_SENDER_MAIN + 5, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE10, GOSSIP_MENU_OPTION_ID_ANSWER_3, GOSSIP_SENDER_MAIN + 2, GOSSIP_ACTION_INFO_DEF);
                    SendGossipMenuFor(player, GOSSIP_MENU_DIPLOMATIC_MISSION, me->GetGUID());
                    break;
                case GOSSIP_ACTION_INFO_DEF + 4:
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE11, GOSSIP_MENU_OPTION_ID_ANSWER_1, GOSSIP_SENDER_MAIN + 6, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE12, GOSSIP_MENU_OPTION_ID_ANSWER_2, GOSSIP_SENDER_MAIN + 7, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE13, GOSSIP_MENU_OPTION_ID_ANSWER_3, GOSSIP_SENDER_MAIN + 8, GOSSIP_ACTION_INFO_DEF);
                    SendGossipMenuFor(player, GOSSIP_MENU_YOUR_BROTHER_SEEKS, me->GetGUID());
                    break;
                case GOSSIP_ACTION_INFO_DEF + 5:
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE14, GOSSIP_MENU_OPTION_ID_ANSWER_1, GOSSIP_SENDER_MAIN + 5, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE15, GOSSIP_MENU_OPTION_ID_ANSWER_2, GOSSIP_SENDER_MAIN + 4, GOSSIP_ACTION_INFO_DEF);
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE16, GOSSIP_MENU_OPTION_ID_ANSWER_3, GOSSIP_SENDER_MAIN + 3, GOSSIP_ACTION_INFO_DEF);
                    SendGossipMenuFor(player, GOSSIP_MENU_A_TERRIBLE_BEAST, me->GetGUID());
                    break;
                case GOSSIP_ACTION_INFO_DEF:
                    AddGossipItemFor(player, GOSSIP_MENU_OPTION_SAYGE17, GOSSIP_MENU_OPTION_ID_ANSWER_1, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 6);
                    SendGossipMenuFor(player, GOSSIP_MENU_YOUR_FORTUNE_IS_CAST, me->GetGUID());
                    break;
                case GOSSIP_ACTION_INFO_DEF + 6:
                    DoCast(player, SPELL_FORTUNE, false);
                    SendGossipMenuFor(player, GOSSIP_MENU_HERE_IS_YOUR_FORTUNE, me->GetGUID());
                    break;
            }
        }

        bool GossipSelect(Player* player, uint32 /*menuId*/, uint32 gossipListId) override
        {
            uint32 const sender = player->PlayerTalkClass->GetGossipOptionSender(gossipListId);
            uint32 const action = player->PlayerTalkClass->GetGossipOptionAction(gossipListId);
            ClearGossipMenuFor(player);
            uint32 spellId = 0;
            switch (sender)
            {
                case GOSSIP_SENDER_MAIN:
                    SendAction(player, action);
                    break;
                case GOSSIP_SENDER_MAIN + 1:
                    spellId = SPELL_DAMAGE;
                    break;
                case GOSSIP_SENDER_MAIN + 2:
                    spellId = SPELL_RESISTANCE;
                    break;
                case GOSSIP_SENDER_MAIN + 3:
                    spellId = SPELL_ARMOR;
                    break;
                case GOSSIP_SENDER_MAIN + 4:
                    spellId = SPELL_SPIRIT;
                    break;
                case GOSSIP_SENDER_MAIN + 5:
                    spellId = SPELL_INTELLECT;
                    break;
                case GOSSIP_SENDER_MAIN + 6:
                    spellId = SPELL_STAMINA;
                    break;
                case GOSSIP_SENDER_MAIN + 7:
                    spellId = SPELL_STRENGTH;
                    break;
                case GOSSIP_SENDER_MAIN + 8:
                    spellId = SPELL_AGILITY;
                    break;
            }

            if (spellId)
            {
                DoCast(player, spellId, false);
                player->GetSpellHistory()->AddCooldown(spellId, 0, std::chrono::hours(2));
                SendAction(player, action);
            }
            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_saygeAI(creature);
    }
};

class npc_steam_tonk : public CreatureScript
{
public:
    npc_steam_tonk() : CreatureScript("npc_steam_tonk") { }

    struct npc_steam_tonkAI : public ScriptedAI
    {
        npc_steam_tonkAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override { }
        void JustEngagedWith(Unit* /*who*/) override { }

        void OnPossess(bool apply)
        {
            if (apply)
            {
                // Initialize the action bar without the melee attack command
                me->InitCharmInfo();
                me->GetCharmInfo()->InitEmptyActionBar(false);

                me->SetReactState(REACT_PASSIVE);
            }
            else
                me->SetReactState(REACT_AGGRESSIVE);
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_steam_tonkAI(creature);
    }
};

enum TonkMine
{
    SPELL_TONK_MINE_DETONATE    = 25099
};

class npc_tonk_mine : public CreatureScript
{
public:
    npc_tonk_mine() : CreatureScript("npc_tonk_mine") { }

    struct npc_tonk_mineAI : public ScriptedAI
    {
        npc_tonk_mineAI(Creature* creature) : ScriptedAI(creature)
        {
            Initialize();
            me->SetReactState(REACT_PASSIVE);
        }

        void Initialize()
        {
            ExplosionTimer = 3000;
        }

        uint32 ExplosionTimer;

        void Reset() override
        {
            Initialize();
        }

        void JustEngagedWith(Unit* /*who*/) override { }
        void AttackStart(Unit* /*who*/) override { }
        void MoveInLineOfSight(Unit* /*who*/) override { }


        void UpdateAI(uint32 diff) override
        {
            if (ExplosionTimer <= diff)
            {
                DoCast(me, SPELL_TONK_MINE_DETONATE, true);
                me->SetDeathState(DEAD); // unsummon it
            }
            else
                ExplosionTimer -= diff;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_tonk_mineAI(creature);
    }
};

/*####
## npc_brewfest_reveler
####*/

enum BrewfestReveler
{
    SPELL_BREWFEST_TOAST = 41586
};

class npc_brewfest_reveler : public CreatureScript
{
    public:
        npc_brewfest_reveler() : CreatureScript("npc_brewfest_reveler") { }

        struct npc_brewfest_revelerAI : public ScriptedAI
        {
            npc_brewfest_revelerAI(Creature* creature) : ScriptedAI(creature) { }

            void ReceiveEmote(Player* player, uint32 emote) override
            {
                if (!sGameEventMgr->IsActiveEvent(HOLIDAY_BREWFEST))
                    return;

                if (emote == TEXTEMOTE_DANCE)
                    me->CastSpell(player, SPELL_BREWFEST_TOAST, false);
            }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_brewfest_revelerAI(creature);
        }
};

enum TrainingDummy
{
    NPC_ADVANCED_TARGET_DUMMY                  = 2674,
    NPC_TARGET_DUMMY                           = 2673
};

class npc_training_dummy : public CreatureScript
{
public:
    npc_training_dummy() : CreatureScript("npc_training_dummy") { }

    struct npc_training_dummyAI : PassiveAI
    {
        npc_training_dummyAI(Creature* creature) : PassiveAI(creature), _combatCheckTimer(500)
        {
            uint32 const entry = me->GetEntry();
            if (entry == NPC_TARGET_DUMMY || entry == NPC_ADVANCED_TARGET_DUMMY)
            {
                _combatCheckTimer = 0;
                me->DespawnOrUnsummon(16s);
            }
        }

        void Reset() override
        {
            _damageTimes.clear();
        }

        void EnterEvadeMode(EvadeReason why) override
        {
            if (!_EnterEvadeMode(why))
                return;

            Reset();
        }

        void DamageTaken(Unit* doneBy, uint32& damage) override
        {
            if (doneBy)
                _damageTimes[doneBy->GetGUID()] = WorldGameTime::GetGameTime();
            damage = 0;
        }

        void UpdateAI(uint32 diff) override
        {
            if (!_combatCheckTimer || !me->IsInCombat())
                return;

            if (diff < _combatCheckTimer)
            {
                _combatCheckTimer -= diff;
                return;
            }

            _combatCheckTimer = 500;

            time_t const now = WorldGameTime::GetGameTime();
            auto const& pveRefs = me->GetCombatManager().GetPvECombatRefs();
            for (auto itr = _damageTimes.begin(); itr != _damageTimes.end();)
            {
                // If unit has not dealt damage to training dummy for 5 seconds, remove him from combat
                if (itr->second < now - 5)
                {
                    auto it = pveRefs.find(itr->first);
                    if (it != pveRefs.end())
                        it->second->EndCombat();

                    itr = _damageTimes.erase(itr);
                }
                else
                    ++itr;
            }

            for (auto const& pair : pveRefs)
                if (_damageTimes.find(pair.first) == _damageTimes.end())
                    _damageTimes[pair.first] = now;
        }

        std::unordered_map<ObjectGuid, time_t> _damageTimes;
        uint32 _combatCheckTimer;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_training_dummyAI(creature);
    }
};

/*######
## npc_pet_trainer
######*/

enum PetTrainer
{
    MENU_ID_PET_UNLEARN      = 6520,
    OPTION_ID_PLEASE_DO      = 0
};

class npc_pet_trainer : public CreatureScript
{
public:
    npc_pet_trainer() : CreatureScript("npc_pet_trainer") { }

    struct npc_pet_trainerAI : public ScriptedAI
    {
        npc_pet_trainerAI(Creature* creature) : ScriptedAI(creature) { }

        bool GossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
        {
            if (menuId == MENU_ID_PET_UNLEARN && gossipListId == OPTION_ID_PLEASE_DO)
            {
				if (player->GetPet())
					player->GetPet()->ResetTalentsCost();
                CloseGossipMenuFor(player);
            }
            return false;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_pet_trainerAI(creature);
    }
};

enum Fireworks
{
    NPC_OMEN                = 15467,
    NPC_MINION_OF_OMEN      = 15466,
    NPC_FIREWORK_BLUE       = 15879,
    NPC_FIREWORK_GREEN      = 15880,
    NPC_FIREWORK_PURPLE     = 15881,
    NPC_FIREWORK_RED        = 15882,
    NPC_FIREWORK_YELLOW     = 15883,
    NPC_FIREWORK_WHITE      = 15884,
    NPC_FIREWORK_BIG_BLUE   = 15885,
    NPC_FIREWORK_BIG_GREEN  = 15886,
    NPC_FIREWORK_BIG_PURPLE = 15887,
    NPC_FIREWORK_BIG_RED    = 15888,
    NPC_FIREWORK_BIG_YELLOW = 15889,
    NPC_FIREWORK_BIG_WHITE  = 15890,

    NPC_CLUSTER_BLUE        = 15872,
    NPC_CLUSTER_RED         = 15873,
    NPC_CLUSTER_GREEN       = 15874,
    NPC_CLUSTER_PURPLE      = 15875,
    NPC_CLUSTER_WHITE       = 15876,
    NPC_CLUSTER_YELLOW      = 15877,
    NPC_CLUSTER_BIG_BLUE    = 15911,
    NPC_CLUSTER_BIG_GREEN   = 15912,
    NPC_CLUSTER_BIG_PURPLE  = 15913,
    NPC_CLUSTER_BIG_RED     = 15914,
    NPC_CLUSTER_BIG_WHITE   = 15915,
    NPC_CLUSTER_BIG_YELLOW  = 15916,
    NPC_CLUSTER_ELUNE       = 15918,

    GO_FIREWORK_LAUNCHER_1  = 180771,
    GO_FIREWORK_LAUNCHER_2  = 180868,
    GO_FIREWORK_LAUNCHER_3  = 180850,
    GO_CLUSTER_LAUNCHER_1   = 180772,
    GO_CLUSTER_LAUNCHER_2   = 180859,
    GO_CLUSTER_LAUNCHER_3   = 180869,
    GO_CLUSTER_LAUNCHER_4   = 180874,

    SPELL_ROCKET_BLUE       = 26344,
    SPELL_ROCKET_GREEN      = 26345,
    SPELL_ROCKET_PURPLE     = 26346,
    SPELL_ROCKET_RED        = 26347,
    SPELL_ROCKET_WHITE      = 26348,
    SPELL_ROCKET_YELLOW     = 26349,
    SPELL_ROCKET_BIG_BLUE   = 26351,
    SPELL_ROCKET_BIG_GREEN  = 26352,
    SPELL_ROCKET_BIG_PURPLE = 26353,
    SPELL_ROCKET_BIG_RED    = 26354,
    SPELL_ROCKET_BIG_WHITE  = 26355,
    SPELL_ROCKET_BIG_YELLOW = 26356,
    SPELL_LUNAR_FORTUNE     = 26522,

    ANIM_GO_LAUNCH_FIREWORK = 3,
    ZONE_MOONGLADE          = 493,
};

Position omenSummonPos = {7558.993f, -2839.999f, 450.0214f, 4.46f};

class npc_firework : public CreatureScript
{
public:
    npc_firework() : CreatureScript("npc_firework") { }

    struct npc_fireworkAI : public ScriptedAI
    {
        npc_fireworkAI(Creature* creature) : ScriptedAI(creature) { }

        bool isCluster()
        {
            switch (me->GetEntry())
            {
                case NPC_FIREWORK_BLUE:
                case NPC_FIREWORK_GREEN:
                case NPC_FIREWORK_PURPLE:
                case NPC_FIREWORK_RED:
                case NPC_FIREWORK_YELLOW:
                case NPC_FIREWORK_WHITE:
                case NPC_FIREWORK_BIG_BLUE:
                case NPC_FIREWORK_BIG_GREEN:
                case NPC_FIREWORK_BIG_PURPLE:
                case NPC_FIREWORK_BIG_RED:
                case NPC_FIREWORK_BIG_YELLOW:
                case NPC_FIREWORK_BIG_WHITE:
                    return false;
                case NPC_CLUSTER_BLUE:
                case NPC_CLUSTER_GREEN:
                case NPC_CLUSTER_PURPLE:
                case NPC_CLUSTER_RED:
                case NPC_CLUSTER_YELLOW:
                case NPC_CLUSTER_WHITE:
                case NPC_CLUSTER_BIG_BLUE:
                case NPC_CLUSTER_BIG_GREEN:
                case NPC_CLUSTER_BIG_PURPLE:
                case NPC_CLUSTER_BIG_RED:
                case NPC_CLUSTER_BIG_YELLOW:
                case NPC_CLUSTER_BIG_WHITE:
                case NPC_CLUSTER_ELUNE:
                default:
                    return true;
            }
        }

        GameObject* FindNearestLauncher()
        {
            GameObject* launcher = nullptr;

            if (isCluster())
            {
                GameObject* launcher1 = GetClosestGameObjectWithEntry(me, GO_CLUSTER_LAUNCHER_1, 0.5f);
                GameObject* launcher2 = GetClosestGameObjectWithEntry(me, GO_CLUSTER_LAUNCHER_2, 0.5f);
                GameObject* launcher3 = GetClosestGameObjectWithEntry(me, GO_CLUSTER_LAUNCHER_3, 0.5f);
                GameObject* launcher4 = GetClosestGameObjectWithEntry(me, GO_CLUSTER_LAUNCHER_4, 0.5f);

                if (launcher1)
                    launcher = launcher1;
                else if (launcher2)
                    launcher = launcher2;
                else if (launcher3)
                    launcher = launcher3;
                else if (launcher4)
                    launcher = launcher4;
            }
            else
            {
                GameObject* launcher1 = GetClosestGameObjectWithEntry(me, GO_FIREWORK_LAUNCHER_1, 0.5f);
                GameObject* launcher2 = GetClosestGameObjectWithEntry(me, GO_FIREWORK_LAUNCHER_2, 0.5f);
                GameObject* launcher3 = GetClosestGameObjectWithEntry(me, GO_FIREWORK_LAUNCHER_3, 0.5f);

                if (launcher1)
                    launcher = launcher1;
                else if (launcher2)
                    launcher = launcher2;
                else if (launcher3)
                    launcher = launcher3;
            }

            return launcher;
        }

        uint32 GetFireworkSpell(uint32 entry)
        {
            switch (entry)
            {
                case NPC_FIREWORK_BLUE:
                    return SPELL_ROCKET_BLUE;
                case NPC_FIREWORK_GREEN:
                    return SPELL_ROCKET_GREEN;
                case NPC_FIREWORK_PURPLE:
                    return SPELL_ROCKET_PURPLE;
                case NPC_FIREWORK_RED:
                    return SPELL_ROCKET_RED;
                case NPC_FIREWORK_YELLOW:
                    return SPELL_ROCKET_YELLOW;
                case NPC_FIREWORK_WHITE:
                    return SPELL_ROCKET_WHITE;
                case NPC_FIREWORK_BIG_BLUE:
                    return SPELL_ROCKET_BIG_BLUE;
                case NPC_FIREWORK_BIG_GREEN:
                    return SPELL_ROCKET_BIG_GREEN;
                case NPC_FIREWORK_BIG_PURPLE:
                    return SPELL_ROCKET_BIG_PURPLE;
                case NPC_FIREWORK_BIG_RED:
                    return SPELL_ROCKET_BIG_RED;
                case NPC_FIREWORK_BIG_YELLOW:
                    return SPELL_ROCKET_BIG_YELLOW;
                case NPC_FIREWORK_BIG_WHITE:
                    return SPELL_ROCKET_BIG_WHITE;
                default:
                    return 0;
            }
        }

        uint32 GetFireworkGameObjectId()
        {
            uint32 spellId = 0;

            switch (me->GetEntry())
            {
                case NPC_CLUSTER_BLUE:
                    spellId = GetFireworkSpell(NPC_FIREWORK_BLUE);
                    break;
                case NPC_CLUSTER_GREEN:
                    spellId = GetFireworkSpell(NPC_FIREWORK_GREEN);
                    break;
                case NPC_CLUSTER_PURPLE:
                    spellId = GetFireworkSpell(NPC_FIREWORK_PURPLE);
                    break;
                case NPC_CLUSTER_RED:
                    spellId = GetFireworkSpell(NPC_FIREWORK_RED);
                    break;
                case NPC_CLUSTER_YELLOW:
                    spellId = GetFireworkSpell(NPC_FIREWORK_YELLOW);
                    break;
                case NPC_CLUSTER_WHITE:
                    spellId = GetFireworkSpell(NPC_FIREWORK_WHITE);
                    break;
                case NPC_CLUSTER_BIG_BLUE:
                    spellId = GetFireworkSpell(NPC_FIREWORK_BIG_BLUE);
                    break;
                case NPC_CLUSTER_BIG_GREEN:
                    spellId = GetFireworkSpell(NPC_FIREWORK_BIG_GREEN);
                    break;
                case NPC_CLUSTER_BIG_PURPLE:
                    spellId = GetFireworkSpell(NPC_FIREWORK_BIG_PURPLE);
                    break;
                case NPC_CLUSTER_BIG_RED:
                    spellId = GetFireworkSpell(NPC_FIREWORK_BIG_RED);
                    break;
                case NPC_CLUSTER_BIG_YELLOW:
                    spellId = GetFireworkSpell(NPC_FIREWORK_BIG_YELLOW);
                    break;
                case NPC_CLUSTER_BIG_WHITE:
                    spellId = GetFireworkSpell(NPC_FIREWORK_BIG_WHITE);
                    break;
                case NPC_CLUSTER_ELUNE:
                    spellId = GetFireworkSpell(urand(NPC_FIREWORK_BLUE, NPC_FIREWORK_WHITE));
                    break;
            }

            SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId);

            if (spellInfo && spellInfo->Effects[0].Effect == SPELL_EFFECT_SUMMON_OBJECT_WILD)
                return spellInfo->Effects[0].MiscValue;

            return 0;
        }

        void Reset() override
        {
            if (GameObject* launcher = FindNearestLauncher())
            {
                launcher->SendCustomAnim(ANIM_GO_LAUNCH_FIREWORK);
                me->SetOrientation(launcher->GetOrientation() + float(M_PI) / 2);
            }
            else
                return;

            if (isCluster())
            {
                // Check if we are near Elune'ara lake south, if so try to summon Omen or a minion
                if (me->GetZoneId() == ZONE_MOONGLADE)
                {
                    if (!me->FindNearestCreature(NPC_OMEN, 100.0f) && me->GetDistance2d(omenSummonPos.GetPositionX(), omenSummonPos.GetPositionY()) <= 100.0f)
                    {
                        switch (urand(0, 9))
                        {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                                if (Creature* minion = me->SummonCreature(NPC_MINION_OF_OMEN, me->GetPositionX()+frand(-5.0f, 5.0f), me->GetPositionY()+frand(-5.0f, 5.0f), me->GetPositionZ(), 0.0f, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 20000))
                                    minion->AI()->AttackStart(me->SelectNearestPlayer(20.0f));
                                break;
                            case 9:
                                me->SummonCreature(NPC_OMEN, omenSummonPos);
                                break;
                        }
                    }
                }
                if (me->GetEntry() == NPC_CLUSTER_ELUNE)
                    DoCast(SPELL_LUNAR_FORTUNE);

                float displacement = 0.7f;
                for (uint8 i = 0; i < 4; i++)
                    me->SummonGameObject(GetFireworkGameObjectId(), me->GetPositionX() + (i % 2 == 0 ? displacement : -displacement), me->GetPositionY() + (i > 1 ? displacement : -displacement), me->GetPositionZ() + 4.0f, me->GetOrientation(), QuaternionData(), 1);
            }
            else
                //me->CastSpell(me, GetFireworkSpell(me->GetEntry()), true);
                me->CastSpell(me->GetPosition(), GetFireworkSpell(me->GetEntry()), true);
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_fireworkAI(creature);
    }
};

class npc_imp_in_a_ball : public CreatureScript
{
private:
    enum
    {
        SAY_RANDOM,

        EVENT_TALK = 1,
    };

public:
    npc_imp_in_a_ball() : CreatureScript("npc_imp_in_a_ball") { }

    struct npc_imp_in_a_ballAI : public ScriptedAI
    {
        npc_imp_in_a_ballAI(Creature* creature) : ScriptedAI(creature)
        {
            summonerGUID.Clear();
        }

        void IsSummonedBy(WorldObject* summoner) override
        {
            if (summoner->GetTypeId() == TYPEID_PLAYER)
            {
                summonerGUID = summoner->GetGUID();
                events.ScheduleEvent(EVENT_TALK, 3s);
            }
        }

        void UpdateAI(uint32 diff) override
        {
            events.Update(diff);

            if (events.ExecuteEvent() == EVENT_TALK)
            {
                if (Player* owner = ObjectAccessor::GetPlayer(*me, summonerGUID))
                {
                    sCreatureTextMgr->SendChat(me, SAY_RANDOM, owner,
                        owner->GetGroup() ? CHAT_MSG_MONSTER_PARTY : CHAT_MSG_MONSTER_WHISPER, LANG_ADDON, TEXT_RANGE_NORMAL);
                }
            }
        }

    private:
        EventMap events;
        ObjectGuid summonerGUID;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_imp_in_a_ballAI(creature);
    }
};

enum StableMasters
{
    SPELL_MINIWING                  = 54573,
    SPELL_JUBLING                   = 54611,
    SPELL_DARTER                    = 54619,
    SPELL_WORG                      = 54631,
    SPELL_SMOLDERWEB                = 54634,
    SPELL_CHIKEN                    = 54677,
    SPELL_WOLPERTINGER              = 54688,

    STABLE_MASTER_GOSSIP_SUB_MENU   = 9820
};

class npc_stable_master : public CreatureScript
{
    public:
        npc_stable_master() : CreatureScript("npc_stable_master") { }

        struct npc_stable_masterAI : public SmartAI
        {
            npc_stable_masterAI(Creature* creature) : SmartAI(creature) { }

            bool GossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
            {
                SmartAI::GossipSelect(player, menuId, gossipListId);
                if (menuId != STABLE_MASTER_GOSSIP_SUB_MENU)
                    return false;

                switch (gossipListId)
                {
                    case 0:
                        player->CastSpell(player, SPELL_MINIWING, false);
                        break;
                    case 1:
                        player->CastSpell(player, SPELL_JUBLING, false);
                        break;
                    case 2:
                        player->CastSpell(player, SPELL_DARTER, false);
                        break;
                    case 3:
                        player->CastSpell(player, SPELL_WORG, false);
                        break;
                    case 4:
                        player->CastSpell(player, SPELL_SMOLDERWEB, false);
                        break;
                    case 5:
                        player->CastSpell(player, SPELL_CHIKEN, false);
                        break;
                    case 6:
                        player->CastSpell(player, SPELL_WOLPERTINGER, false);
                        break;
                    default:
                        return false;
                }

                player->PlayerTalkClass->SendCloseGossip();
                return false;
            }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_stable_masterAI(creature);
        }
};

enum BountifulTable
{
    SEAT_TURKEY_CHAIR                       = 0,
    SEAT_CRANBERRY_CHAIR                    = 1,
    SEAT_STUFFING_CHAIR                     = 2,
    SEAT_SWEET_POTATO_CHAIR                 = 3,
    SEAT_PIE_CHAIR                          = 4,
    SEAT_FOOD_HOLDER                        = 5,
    SEAT_PLATE_HOLDER                       = 6,
    NPC_THE_TURKEY_CHAIR                    = 34812,
    NPC_THE_CRANBERRY_CHAIR                 = 34823,
    NPC_THE_STUFFING_CHAIR                  = 34819,
    NPC_THE_SWEET_POTATO_CHAIR              = 34824,
    NPC_THE_PIE_CHAIR                       = 34822,
    SPELL_CRANBERRY_SERVER                  = 61793,
    SPELL_PIE_SERVER                        = 61794,
    SPELL_STUFFING_SERVER                   = 61795,
    SPELL_TURKEY_SERVER                     = 61796,
    SPELL_SWEET_POTATOES_SERVER             = 61797
};

typedef std::unordered_map<uint32 /*Entry*/, uint32 /*Spell*/> ChairSpells;
ChairSpells const _chairSpells =
{
    { NPC_THE_CRANBERRY_CHAIR, SPELL_CRANBERRY_SERVER },
    { NPC_THE_PIE_CHAIR, SPELL_PIE_SERVER },
    { NPC_THE_STUFFING_CHAIR, SPELL_STUFFING_SERVER },
    { NPC_THE_TURKEY_CHAIR, SPELL_TURKEY_SERVER },
    { NPC_THE_SWEET_POTATO_CHAIR, SPELL_SWEET_POTATOES_SERVER },
};

class CastFoodSpell : public BasicEvent
{
    public:
        CastFoodSpell(Unit* owner, uint32 spellId) : _owner(owner), _spellId(spellId) { }

        bool Execute(uint64 /*execTime*/, uint32 /*diff*/) override
        {
            _owner->CastSpell(_owner, _spellId, true);
            return true;
        }

    private:
        Unit* _owner;
        uint32 _spellId;
};

void AddSC_npcs_special()
{
    new npc_air_force_bots();
    new npc_chicken_cluck();
    new npc_dancing_flames();
    new npc_torch_tossing_target_bunny_controller();
    new npc_midsummer_bunny_pole();
    new npc_doctor();
    new npc_injured_patient();
    new npc_garments_of_quests();
    new npc_guardian();
    new npc_sayge();
    new npc_steam_tonk();
    new npc_tonk_mine();
    new npc_brewfest_reveler();
    new npc_training_dummy();
    new npc_pet_trainer();
    new npc_firework();
    new npc_imp_in_a_ball();
    new npc_stable_master();
}
