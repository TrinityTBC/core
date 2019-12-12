/*
 * Copyright (C) 2008-2019 TrinityCore <https://www.trinitycore.org/>
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
#include "MotionMaster.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include "SpellAuras.h"

enum Orphans
{
    ORPHAN_ORACLE                           = 33533,
    ORPHAN_WOLVAR                           = 33532,
    ORPHAN_BLOOD_ELF                        = 22817,
    ORPHAN_DRAENEI                          = 22818,
    ORPHAN_HUMAN                            = 14305,
    ORPHAN_ORCISH                           = 14444
};

enum Texts
{
    TEXT_ORACLE_ORPHAN_1                    = 1,
    TEXT_ORACLE_ORPHAN_2                    = 2,
    TEXT_ORACLE_ORPHAN_3                    = 3,
    TEXT_ORACLE_ORPHAN_4                    = 4,
    TEXT_ORACLE_ORPHAN_5                    = 5,
    TEXT_ORACLE_ORPHAN_6                    = 6,
    TEXT_ORACLE_ORPHAN_7                    = 7,
    TEXT_ORACLE_ORPHAN_8                    = 8,
    TEXT_ORACLE_ORPHAN_9                    = 9,
    TEXT_ORACLE_ORPHAN_10                   = 10,
    TEXT_ORACLE_ORPHAN_11                   = 11,
    TEXT_ORACLE_ORPHAN_12                   = 12,
    TEXT_ORACLE_ORPHAN_13                   = 13,
    TEXT_ORACLE_ORPHAN_14                   = 14,

    TEXT_WOLVAR_ORPHAN_1                    = 1,
    TEXT_WOLVAR_ORPHAN_2                    = 2,
    TEXT_WOLVAR_ORPHAN_3                    = 3,
    TEXT_WOLVAR_ORPHAN_4                    = 4,
    TEXT_WOLVAR_ORPHAN_5                    = 5,
    // 6 - 9 used in Nesingwary script
    TEXT_WOLVAR_ORPHAN_10                   = 10,
    TEXT_WOLVAR_ORPHAN_11                   = 11,
    TEXT_WOLVAR_ORPHAN_12                   = 12,
    TEXT_WOLVAR_ORPHAN_13                   = 13,

    TEXT_WINTERFIN_PLAYMATE_1               = 1,
    TEXT_WINTERFIN_PLAYMATE_2               = 2,

    TEXT_SNOWFALL_GLADE_PLAYMATE_1          = 1,
    TEXT_SNOWFALL_GLADE_PLAYMATE_2          = 2,

    TEXT_SOO_ROO_1                          = 1,
    TEXT_ELDER_KEKEK_1                      = 1,

    TEXT_ALEXSTRASZA_2                      = 2,
    TEXT_KRASUS_8                           = 8
};

enum Quests
{
    QUEST_PLAYMATE_WOLVAR                   = 13951,
    QUEST_PLAYMATE_ORACLE                   = 13950,
    QUEST_THE_BIGGEST_TREE_EVER             = 13929,
    QUEST_THE_BRONZE_DRAGONSHRINE_ORACLE    = 13933,
    QUEST_THE_BRONZE_DRAGONSHRINE_WOLVAR    = 13934,
    QUEST_MEETING_A_GREAT_ONE               = 13956,
    QUEST_THE_MIGHTY_HEMET_NESINGWARY       = 13957,
    QUEST_DOWN_AT_THE_DOCKS                 = 910,
    QUEST_GATEWAY_TO_THE_FRONTIER           = 911,
    QUEST_BOUGHT_OF_ETERNALS                = 1479,
    QUEST_SPOOKY_LIGHTHOUSE                 = 1687,
    QUEST_STONEWROUGHT_DAM                  = 1558,
    QUEST_DARK_PORTAL_H                     = 10951,
    QUEST_DARK_PORTAL_A                     = 10952,
    QUEST_LORDAERON_THRONE_ROOM             = 1800,
    QUEST_AUCHINDOUN_AND_THE_RING           = 10950,
    QUEST_TIME_TO_VISIT_THE_CAVERNS_H       = 10963,
    QUEST_TIME_TO_VISIT_THE_CAVERNS_A       = 10962,
    QUEST_THE_SEAT_OF_THE_NARUU             = 10956,
    QUEST_CALL_ON_THE_FARSEER               = 10968,
    QUEST_JHEEL_IS_AT_AERIS_LANDING         = 10954,
    QUEST_HCHUU_AND_THE_MUSHROOM_PEOPLE     = 10945,
    QUEST_VISIT_THE_THRONE_OF_ELEMENTS      = 10953,
    QUEST_NOW_WHEN_I_GROW_UP                = 11975,
    QUEST_HOME_OF_THE_BEAR_MEN              = 13930,
    QUEST_THE_DRAGON_QUEEN_ORACLE           = 13954,
    QUEST_THE_DRAGON_QUEEN_WOLVAR           = 13955
};

enum Areatriggers
{
    AT_DOWN_AT_THE_DOCKS                    = 3551,
    AT_GATEWAY_TO_THE_FRONTIER              = 3549,
    AT_LORDAERON_THRONE_ROOM                = 3547,
    AT_BOUGHT_OF_ETERNALS                   = 3546,
    AT_SPOOKY_LIGHTHOUSE                    = 3552,
    AT_STONEWROUGHT_DAM                     = 3548,
    AT_DARK_PORTAL                          = 4356,

    NPC_CAVERNS_OF_TIME_CW_TRIGGER          = 22872,
    NPC_EXODAR_01_CW_TRIGGER                = 22851,
    NPC_EXODAR_02_CW_TRIGGER                = 22905,
    NPC_AERIS_LANDING_CW_TRIGGER            = 22838,
    NPC_AUCHINDOUN_CW_TRIGGER               = 22831,
    NPC_SPOREGGAR_CW_TRIGGER                = 22829,
    NPC_THRONE_OF_ELEMENTS_CW_TRIGGER       = 22839,
    NPC_SILVERMOON_01_CW_TRIGGER            = 22866,
    NPC_KRASUS                              = 27990
};

enum Misc
{
    SPELL_SNOWBALL                          = 21343,
    SPELL_ORPHAN_OUT                        = 58818,

    DISPLAY_INVISIBLE                       = 11686
};

ObjectGuid getOrphanGUID(Player* player, uint32 orphan)
{
    if (Aura* orphanOut = player->GetAura(SPELL_ORPHAN_OUT))
        if (orphanOut->GetCaster() && orphanOut->GetCaster()->GetEntry() == orphan)
            return orphanOut->GetCaster()->GetGUID();

    return ObjectGuid::Empty;
}

/*######
## at_bring_your_orphan_to
######*/

class at_bring_your_orphan_to : public AreaTriggerScript
{
    public:
        at_bring_your_orphan_to() : AreaTriggerScript("at_bring_your_orphan_to") { }

        bool OnTrigger(Player* player, AreaTriggerEntry const* trigger) override
        {
            if (player->isDead() || !player->HasAura(SPELL_ORPHAN_OUT))
                return false;

            uint32 questId = 0;
            uint32 orphanId = 0;

            switch (trigger->id)
            {
                case AT_DOWN_AT_THE_DOCKS:
                    questId = QUEST_DOWN_AT_THE_DOCKS;
                    orphanId = ORPHAN_ORCISH;
                    break;
                case AT_GATEWAY_TO_THE_FRONTIER:
                    questId = QUEST_GATEWAY_TO_THE_FRONTIER;
                    orphanId = ORPHAN_ORCISH;
                    break;
                case AT_LORDAERON_THRONE_ROOM:
                    questId = QUEST_LORDAERON_THRONE_ROOM;
                    orphanId = ORPHAN_ORCISH;
                    break;
                case AT_BOUGHT_OF_ETERNALS:
                    questId = QUEST_BOUGHT_OF_ETERNALS;
                    orphanId = ORPHAN_HUMAN;
                    break;
                case AT_SPOOKY_LIGHTHOUSE:
                    questId = QUEST_SPOOKY_LIGHTHOUSE;
                    orphanId = ORPHAN_HUMAN;
                    break;
                case AT_STONEWROUGHT_DAM:
                    questId = QUEST_STONEWROUGHT_DAM;
                    orphanId = ORPHAN_HUMAN;
                    break;
                case AT_DARK_PORTAL:
                    questId = player->GetTeam() == ALLIANCE ? QUEST_DARK_PORTAL_A : QUEST_DARK_PORTAL_H;
                    orphanId = player->GetTeam() == ALLIANCE ? ORPHAN_DRAENEI : ORPHAN_BLOOD_ELF;
                    break;
            }

            if (questId && orphanId && getOrphanGUID(player, orphanId) && player->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
                player->AreaExploredOrEventHappens(questId);

            return true;
        }
};

/*######
## npc_cw_area_trigger
######*/
class npc_cw_area_trigger : public CreatureScript
{
    public:
        npc_cw_area_trigger() : CreatureScript("npc_cw_area_trigger") { }

        struct npc_cw_area_triggerAI : public ScriptedAI
        {
            npc_cw_area_triggerAI(Creature* creature) : ScriptedAI(creature)
            {
                me->SetDisplayId(DISPLAY_INVISIBLE);
            }

            void MoveInLineOfSight(Unit* who) override
            {
                if (who && me->GetDistance2d(who) < 20.0f)
                    if (Player* player = who->ToPlayer())
                        if (player->HasAura(SPELL_ORPHAN_OUT))
                        {
                            uint32 questId = 0;
                            uint32 orphanId = 0;
                            switch (me->GetEntry())
                            {
                                case NPC_CAVERNS_OF_TIME_CW_TRIGGER:
                                    questId = player->GetTeam() == ALLIANCE ? QUEST_TIME_TO_VISIT_THE_CAVERNS_A : QUEST_TIME_TO_VISIT_THE_CAVERNS_H;
                                    orphanId = player->GetTeam() == ALLIANCE ? ORPHAN_DRAENEI : ORPHAN_BLOOD_ELF;
                                    break;
                                case NPC_EXODAR_01_CW_TRIGGER:
                                    questId = QUEST_THE_SEAT_OF_THE_NARUU;
                                    orphanId = ORPHAN_DRAENEI;
                                    break;
                                case NPC_EXODAR_02_CW_TRIGGER:
                                    questId = QUEST_CALL_ON_THE_FARSEER;
                                    orphanId = ORPHAN_DRAENEI;
                                    break;
                                case NPC_AERIS_LANDING_CW_TRIGGER:
                                    questId = QUEST_JHEEL_IS_AT_AERIS_LANDING;
                                    orphanId = ORPHAN_DRAENEI;
                                    break;
                                case NPC_AUCHINDOUN_CW_TRIGGER:
                                    questId = QUEST_AUCHINDOUN_AND_THE_RING;
                                    orphanId = ORPHAN_DRAENEI;
                                    break;
                                case NPC_SPOREGGAR_CW_TRIGGER:
                                    questId = QUEST_HCHUU_AND_THE_MUSHROOM_PEOPLE;
                                    orphanId = ORPHAN_BLOOD_ELF;
                                    break;
                                case NPC_THRONE_OF_ELEMENTS_CW_TRIGGER:
                                    questId = QUEST_VISIT_THE_THRONE_OF_ELEMENTS;
                                    orphanId = ORPHAN_BLOOD_ELF;
                                    break;
                                case NPC_SILVERMOON_01_CW_TRIGGER:
                                    if (player->GetQuestStatus(QUEST_NOW_WHEN_I_GROW_UP) == QUEST_STATUS_INCOMPLETE && getOrphanGUID(player, ORPHAN_BLOOD_ELF))
                                    {
                                        player->AreaExploredOrEventHappens(QUEST_NOW_WHEN_I_GROW_UP);
                                        if (player->GetQuestStatus(QUEST_NOW_WHEN_I_GROW_UP) == QUEST_STATUS_COMPLETE)
                                            if (Creature* samuro = me->FindNearestCreature(25151, 20.0f))
                                            {
                                                uint32 emote = 0;
                                                switch (urand(1, 5))
                                                {
                                                    case 1:
                                                        emote = EMOTE_ONESHOT_WAVE;
                                                        break;
                                                    case 2:
                                                        emote = EMOTE_ONESHOT_ROAR;
                                                        break;
                                                    case 3:
                                                        emote = EMOTE_ONESHOT_FLEX;
                                                        break;
                                                    case 4:
                                                        emote = EMOTE_ONESHOT_SALUTE;
                                                        break;
                                                    case 5:
                                                        emote = EMOTE_ONESHOT_DANCE;
                                                        break;
                                                }
                                                samuro->HandleEmoteCommand(emote);
                                            }
                                    }
                                    break;
                            }
                            if (questId && orphanId && getOrphanGUID(player, orphanId) && player->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
                                player->AreaExploredOrEventHappens(questId);
                        }
            }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_cw_area_triggerAI(creature);
        }
};

void AddSC_event_childrens_week()
{
    new at_bring_your_orphan_to();
    new npc_cw_area_trigger();
}
