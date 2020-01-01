
#ifndef TRINITYCORE_CREATURE_H
#define TRINITYCORE_CREATURE_H

#include "Common.h"
#include "Unit.h"
#include "CreatureData.h"
#include "LootMgr.h"
#include "CreatureGroups.h"
#include "Duration.h"
#include "Loot.h"
#include "WorldPacket.h"

#include <list>
#include <string>

class SpellInfo;

class CreatureAI;
class Quest;
class Player;
class WorldSession;
class CreatureGroup;
class TempSummon;
class Group;

enum MovementGeneratorType : uint8;

struct VendorItemCount
{
    explicit VendorItemCount(uint32 _item, uint32 _count);

    uint32 itemId;
    uint32 count;
    time_t lastIncrementTime;
};

typedef std::list<VendorItemCount> VendorItemCounts;

// max different by z coordinate for creature aggro reaction
#define CREATURE_Z_ATTACK_RANGE 3
#define CREATURE_MAX_DEATH_WARN_RANGE 60.0f

#ifdef LICH_KING
#define MAX_VENDOR_ITEMS 150                                // Limitation in 3.x.x item count in SMSG_LIST_INVENTORY
#else
#define MAX_VENDOR_ITEMS 255                                // Limitation in item count field size in SMSG_LIST_INVENTORY
#endif

//used for handling non-repeatable random texts
typedef std::vector<uint8> CreatureTextRepeatIds;
typedef std::unordered_map<uint8, CreatureTextRepeatIds> CreatureTextRepeatGroup;

class TC_GAME_API Creature : public Unit, public GridObject<Creature>, public MapObject
{
    friend class TestCase;

    public:

        explicit Creature(bool isWorldObject = false);
        ~Creature() override;

        void AddToWorld() override;
        void RemoveFromWorld() override;
        
        virtual void SetObjectScale(float scale) override;
        virtual void SetDisplayId(uint32 modelId) override;

        void DisappearAndDie();

        bool Create(ObjectGuid::LowType guidlow, Map *map, uint32 phaseMask, uint32 entry, Position const& pos, const CreatureData *data = nullptr, bool dynamic = false);
        //reapply creature addon data to creature
        bool LoadCreaturesAddon();
        void SelectLevel();
        void UpdateLevelDependantStats();
        void SetVirtualItem(WeaponAttackType slot, uint32 item_id);
        void LoadEquipment(int8 id = 1, bool force = false);
        void SetSpawnHealth();
        //Set creature visual weapon (prefer creating values in creature_equip_template in db and loading them with LoadEquipment)
        void SetWeapon(WeaponAttackType slot, uint32 displayid, ItemSubclassWeapon subclass, InventoryType inventoryType);
        //Get ItemSubclassWeapon based on UNIT_VIRTUAL_ITEM_INFO
        ItemSubclassWeapon GetWeaponSubclass(WeaponAttackType slot);
        bool HasMainWeapon() const override;

        ObjectGuid::LowType GetSpawnId() const { return m_spawnId; }
        std::string const& GetTitle() const { return GetCreatureTemplate()->Title; }

        void Update( uint32 time ) override;
        void GetRespawnPosition(float &x, float &y, float &z, float* ori = nullptr, float* dist =nullptr) const;
        bool IsSpawnedOnTransport() const;

        void SetCorpseDelay(uint32 delay) { m_corpseDelay = delay; }
        bool isRacialLeader() const { return GetCreatureTemplate()->RacialLeader; }
        bool IsCivilian() const { return GetCreatureTemplate()->flags_extra & CREATURE_FLAG_EXTRA_CIVILIAN; }
        bool IsTrigger() const { return GetCreatureTemplate()->flags_extra & CREATURE_FLAG_EXTRA_TRIGGER; }
        bool IsDungeonBoss() const { return (GetCreatureTemplate()->flags_extra & CREATURE_FLAG_EXTRA_DUNGEON_BOSS) != 0; }
        bool IsAffectedByDiminishingReturns() const override { return Unit::IsAffectedByDiminishingReturns() /*|| (GetCreatureTemplate()->flags_extra & CREATURE_FLAG_EXTRA_ALL_DIMINISH) != 0*/; }

        Unit* SelectVictim(bool evade = true);

        void SetReactState(ReactStates st);
        ReactStates GetReactState() { return m_reactState; }
        bool HasReactState(ReactStates state) const { return (m_reactState == state); }
        void InitializeReactState();

        using Unit::IsImmuneToAll;
        using Unit::SetImmuneToAll;
        void SetImmuneToAll(bool apply) override { Unit::SetImmuneToAll(apply, HasReactState(REACT_PASSIVE)); }
        using Unit::IsImmuneToPC;
        using Unit::SetImmuneToPC;
        void SetImmuneToPC(bool apply) override { Unit::SetImmuneToPC(apply, HasReactState(REACT_PASSIVE)); }
        using Unit::IsImmuneToNPC;
        using Unit::SetImmuneToNPC;
        void SetImmuneToNPC(bool apply) override { Unit::SetImmuneToNPC(apply, HasReactState(REACT_PASSIVE)); }

        bool isCanInteractWithBattleMaster(Player* player, bool msg) const;
        bool CanResetTalents(Player* player, bool pet) const;
        bool IsOutOfThreatArea(Unit const* pVictim) const;
        bool IsImmunedToSpell(SpellInfo const* spellInfo, WorldObject const* caster) const override;
        bool IsImmunedToSpellEffect(SpellInfo const* spellInfo, uint32 index, WorldObject const* caster) const override;
        void LoadTemplateImmunities();

        bool isElite() const
        {
            if(IsPet())
                return false;

            uint32 rank = GetCreatureTemplate()->rank;
            return rank != CREATURE_ELITE_NORMAL && rank != CREATURE_ELITE_RARE;
        }
        //same as CanCreatureAttack from TC but returns a CanAttackResult instead. Added a _ to the name to avoid confusion.
        CanAttackResult _CanCreatureAttack(Unit const* target, bool force = true) const;
        //TC compat
        bool CanCreatureAttack(Unit const* victim, bool force = true) const
        {
            return _CanCreatureAttack(victim, force) == CAN_ATTACK_RESULT_OK;
        }

        bool IsWorldBoss() const
        {
            if(IsPet())
                return false;

            return GetCreatureTemplate()->IsWorldBoss();
        }
        bool IsGuard() const override { return (m_creatureInfo->flags_extra & CREATURE_FLAG_EXTRA_GUARD) != 0; }

        uint8 GetLevelForTarget(WorldObject const* target) const override; // overwrite Unit::GetLevelForTarget for boss level support

        bool isMoving();
        bool IsInEvadeMode() const;

        //remove previous AI, reselect a new one and initilalize it. Also reset movement.
        //@ai assign this AI
        bool AIM_Destroy();
        bool AIM_Create(CreatureAI* ai = nullptr);
        bool AIM_Initialize(CreatureAI* ai = nullptr);
        void Motion_Initialize();

        void WarnDeathToFriendly();

        CreatureAI* AI() const { return reinterpret_cast<CreatureAI*>(GetAI()); }

        uint32 GetShieldBlockValue() const override                  //dunno mob block value
        {
            return (GetLevel()/2 + uint32(GetStat(STAT_STRENGTH)/20));
        }

        SpellSchoolMask GetMeleeDamageSchoolMask(WeaponAttackType /*attackType*/ = BASE_ATTACK, uint8 /*damageIndex*/ = 0) const override { return m_meleeDamageSchoolMask; }
        void SetMeleeDamageSchool(SpellSchools school) { m_meleeDamageSchoolMask = SpellSchoolMask(1 << school); }

        bool HasSpell(uint32 spellID) const override;

        bool UpdateEntry(uint32 entry, const CreatureData* data = nullptr);
        /* 
        Updates creatures movement flags according to current position
        Remove flying movement flags if creature is not in air.
        Add flying movement flags if creature can fly is in air and not flying.
        Also set creature as swimming if in water
        Won't update if current position is very close to the last one when updating. Force update with argument 'force'
        forPosition: check for given position instead
        */
        void UpdateMovementFlags(bool force = false, Optional<Position> forPosition = {});

        bool UpdateStats(Stats stat) override;
        bool UpdateAllStats() override;
        void UpdateResistances(uint32 school) override;
        void UpdateArmor() override;
        void UpdateMaxHealth() override;
        void UpdateMaxPower(Powers power) override;
        void UpdateAttackPowerAndDamage(bool ranged = false) override;
        void CalculateMinMaxDamage(WeaponAttackType attType, bool normalized, bool addTotalPct, float& minDamage, float& maxDamage, uint8 damageIndex) const override;

        int8 GetOriginalEquipmentId() const { return m_originalEquipmentId; }
        uint32 GetCurrentEquipmentId() { return m_equipmentId; }
        void SetCurrentEquipmentId(uint8 id) { m_equipmentId = id; }

        VendorItemData const* GetVendorItems() const;
        uint32 GetVendorItemCurrentCount(VendorItem const* vItem);
        uint32 UpdateVendorItemCurrentCount(VendorItem const* vItem, uint32 used_count);

        CreatureTemplate const *GetCreatureTemplate() const { return m_creatureInfo; }
        CreatureData const* GetCreatureData() const { return m_creatureData; }
        CreatureAddon const* GetCreatureAddon() const;

        std::string GetScriptName() const;
        uint32 GetScriptId() const;
        std::string GetAIName() const;

        void ResetCreatureEmote();

        // overwrite WorldObject function for proper name localization
        std::string const& GetNameForLocaleIdx(LocaleConstant locale_idx) const override;

        void SetDeathState(DeathState s) override;                   // overwrite virtual Unit::setDeathState

        bool LoadFromDB(ObjectGuid::LowType spawnId, Map* map, bool addToMap, bool allowDuplicate);
        void SaveToDB();
                                                            // overwrited in Pet
        virtual void SaveToDB(uint32 mapid, uint8 spawnMask);
        virtual void DeleteFromDB();                        // overwrited in Pet

        Loot loot;
        void StartPickPocketRefillTimer();
        void ResetPickPocketRefillTimer() { _pickpocketLootRestore = 0; }
        bool CanGeneratePickPocketLoot() const;
        ObjectGuid GetLootRecipientGUID() const { return m_lootRecipient; }
        Player* GetLootRecipient() const;
        Group* GetLootRecipientGroup() const;
        bool hasLootRecipient() const { return m_lootRecipient != 0 || m_lootRecipientGroup; }
        bool isTappedBy(Player const* player) const;                          // return true if the creature is tapped by the player or a member of his party.

        void SetLootRecipient(Unit* unit, bool withGroup = true);
        void AllLootRemovedFromCorpse();

        uint16 GetLootMode() const { return m_LootMode; }
        bool HasLootMode(uint16 lootMode) { return (m_LootMode & lootMode) != 0; }
        void SetLootMode(uint16 lootMode) { m_LootMode = lootMode; }
        void AddLootMode(uint16 lootMode) { m_LootMode |= lootMode; }
        void RemoveLootMode(uint16 lootMode) { m_LootMode &= ~lootMode; }
        void ResetLootMode() { m_LootMode = LOOT_MODE_DEFAULT; }

        SpellInfo const* reachWithSpellAttack(Unit *pVictim);
        SpellInfo const* reachWithSpellCure(Unit *pVictim);

        uint32 m_spells[MAX_CREATURE_SPELLS];

        bool IsWithinSightDist(Unit const* u) const;
        /* Return if creature can aggro and start attacking target, depending on faction, distance, LoS, if target is attackable, ...
        @skip los and distance check instead of standard aggro.
        */
        CanAttackResult CanAggro(Unit const* u, bool force = false) const;
        float GetAggroRange(Unit const* pl) const;
        bool CanStartAttack(Unit const* u, bool force) const;
        float GetAttackDistance(Unit const* player) const;
        
        /** The "suspicious look" is a warning whenever a stealth player is about to be detected by a creature*/
        /* return true if the creature can do a suspicious look on target. This does NOT check for detection range, use CanAggro, CanAttack or CanDetectStealthOf results to ensure this distance is correct. */
        bool CanDoStealthAlert(Unit const* target) const;
        //start lookup suspicously at target
        void StartStealthAlert(Unit const* target);

        Unit* SelectNearestTarget(float dist = 0, bool playerOnly = false, bool furthest = false) const;
        //select nearest alive player
        Unit* SelectNearestTargetInAttackDistance(float dist) const;
		Unit* SelectNearestHostileUnitInAggroRange(bool useLOS = false) const;

        /** Call assistance at short range (chain aggro mechanic) */
        void CallAssistance();
        /** Actively call for help, does NOT check for faction, all friendly are eligibles */
        void CallForHelp(float fRadius);
        void SetNoCallAssistance(bool val) { m_AlreadyCallAssistance = val; }
        bool CanCallAssistance() { return !m_AlreadyCallAssistance; }
        bool CanAssistTo(const Unit* u, const Unit* enemy, bool checkFaction = true) const;
        bool _IsTargetAcceptable(Unit const* target) const;
        void DoFleeToGetAssistance(float radius = 50);


        MovementGeneratorType GetDefaultMovementType() const override { return m_defaultMovementType; }
        void SetDefaultMovementType(MovementGeneratorType mgt) { m_defaultMovementType = mgt; }

        void RemoveCorpse(bool setSpawnTime = true, bool destroyForNearbyPlayers = true);

        void DespawnOrUnsummon(uint32 msTimeToDespawn = 0, Seconds forceRespawnTime = Seconds(0));
        void DespawnOrUnsummon(Milliseconds const& time, Seconds forceRespawnTime = Seconds(0)) { DespawnOrUnsummon(uint32(time.count()), forceRespawnTime); }

        time_t const& GetRespawnTime() const { return m_respawnTime; }
        time_t GetRespawnTimeEx() const;
        void SetRespawnTime(uint32 respawn);
        void Respawn(bool force = false);
        void SaveRespawnTime(uint32 forceDelay = 0, bool savetodb = true) override;

        uint32 GetRespawnDelay() const { return m_respawnDelay; }
        void SetRespawnDelay(uint32 delay) { m_respawnDelay = delay; }

        float GetRespawnRadius() const { return m_respawnradius; }
        void SetRespawnRadius(float dist) { m_respawnradius = dist; }

        void DoImmediateBoundaryCheck() { m_boundaryCheckTime = 0; }
        uint32 GetCombatPulseDelay() const { return m_combatPulseDelay; }
        void SetCombatPulseDelay(uint32 delay) // (secs) interval at which the creature pulses the entire zone into combat (only works in dungeons)
        {
            m_combatPulseDelay = delay;
            if (m_combatPulseTime == 0 || m_combatPulseTime > delay)
                m_combatPulseTime = delay;
        }

        uint32 m_groupLootTimer;                            // (msecs)timer used for group loot
        ObjectGuid::LowType lootingGroupLowGUID;                         // used to find group which is looting corpse

        void SendZoneUnderAttackMessage(Player* attacker);

        bool HasQuest(uint32 quest_id) const override;
        bool HasInvolvedQuest(uint32 quest_id)  const override;

        bool isRegeneratingHealth() { return m_regenHealth; }
        void setRegeneratingHealth(bool regenHealth) { m_regenHealth = regenHealth; }
        virtual uint8 GetPetAutoSpellSize() const { return MAX_CREATURE_SPELLS; }
		virtual uint32 GetPetAutoSpellOnPos(uint8 pos) const;
		float GetPetChaseDistance() const;

        void SetHomePosition(float x, float y, float z, float o) { m_homePosition.Relocate(x, y, z, o); }
        void SetHomePosition(const Position &pos) { m_homePosition.Relocate(pos); }
        void GetHomePosition(float& x, float& y, float& z, float& ori) const { m_homePosition.GetPosition(x, y, z, ori); }
        Position const& GetHomePosition() const { return m_homePosition; }
        float GetDistanceFromHome() const;

        void SetTransportHomePosition(float x, float y, float z, float o) { m_transportHomePosition.Relocate(x, y, z, o); }
        void SetTransportHomePosition(const Position &pos) { m_transportHomePosition.Relocate(pos); }
        void GetTransportHomePosition(float& x, float& y, float& z, float& ori) const { m_transportHomePosition.GetPosition(x, y, z, ori); }
        Position const& GetTransportHomePosition() const { return m_transportHomePosition; }

        uint32 GetWaypointPath() const { return _waypointPathId; }
        void LoadPath(uint32 pathid) { _waypointPathId = pathid; }

        std::pair<uint32, uint32> GetCurrentWaypointInfo() const { return _currentWaypointNodeInfo; }
        void UpdateCurrentWaypointInfo(uint32 nodeId, uint32 pathId) { _currentWaypointNodeInfo = { nodeId, pathId }; }

        bool IsReturningHome() const;

        //check if creature is present in a formation from FormationMgr, and adds it to it if one is found
        void SearchFormation();
        CreatureGroup *GetFormation(){return m_formation;}
        void SetFormation(CreatureGroup *formation) {m_formation = formation;}
        bool IsFormationLeader() const;
        void SignalFormationMovement(Position const& destination, uint32 id = 0, uint32 moveType = 0, bool orientation = false);
        bool IsFormationLeaderMoveAllowed() const;

        void SetDisableReputationGain(bool disable) { disableReputationGain = disable; }
        bool IsReputationGainDisabled() const { return disableReputationGain; }
        bool IsDamageEnoughForLootingAndReward() const { return (m_creatureInfo->flags_extra & CREATURE_FLAG_EXTRA_NO_PLAYER_DAMAGE_REQ) || (m_PlayerDamageReq == 0); }
        void LowerPlayerDamageReq(uint32 unDamage)
        {
            if(m_PlayerDamageReq)
                m_PlayerDamageReq > unDamage ? m_PlayerDamageReq -= unDamage : m_PlayerDamageReq = 0;
        }
        void ResetPlayerDamageReq() { m_PlayerDamageReq = GetHealth() / 2; }
        uint32 m_PlayerDamageReq;

        uint32 GetOriginalEntry() const { return m_originalEntry; }
        void SetOriginalEntry(uint32 entry) { m_originalEntry = entry; }

        // Part of Evade mechanics
        time_t GetLastDamagedTime() const { return m_lastDamagedTime; }
        void SetLastDamagedTime(time_t val) { m_lastDamagedTime = val; }

        /** This is only filled for world bosses */
        bool HadPlayerInThreatListAtDeath(ObjectGuid guid) const;
        void ConvertThreatListIntoPlayerListAtDeath();
        std::set<uint32> const& GetThreatListAtDeath() const { return m_playerInThreatListAtDeath; }

        // Respawned since less than 5 secs
        bool HasJustAppeared() const { return (m_timeSinceSpawn < 5000); }
        void ResetCorpseRemoveTime(); //set corpse remove time at max time
        uint32 GetCorpseDelay() const { return m_corpseDelay; }
        
        // Scripting tools
        bool IsBelowHPPercent(float percent);
        bool IsAboveHPPercent(float percent);
        bool IsBetweenHPPercent(float minPercent, float maxPercent);
        
        //Play message for current creature when given time is elapsed. /!\ These events are udpated only if creature is alive
        void AddMessageEvent(uint64 timer, uint32 messageId, uint64 data = 0);

        CreatureMovementData const& GetMovementTemplate() const;
        bool CanWalk() const override { return GetMovementTemplate().IsGroundAllowed(); }
        bool CanSwim() const override { return GetMovementTemplate().IsSwimAllowed() || IsPet(); }
        bool CanFly()  const override { return GetMovementTemplate().IsFlightAllowed() || m_canFly; }
        bool CanHover() const { return GetMovementTemplate().Ground == CreatureGroundMovementType::Hover; }

        bool SetWalk(bool enable) override;
        bool SetSwim(bool enable) override;
        // /!\ Not TC SetCanFly. This marks creature as able to fly, rather than making it fly. You can then call UpdateMovementFlags() if you want to update fly mode immediately.
        void _SetCanFly(bool enable, bool updateMovementFlags = true);
        // /!\ This is TC SetCanFly equivalent
        void SetFlying(bool enable) override;

        float m_SightDistance;

        // There's many places not ready for dynamic spawns. This allows them to live on for now.
        void SetRespawnCompatibilityMode(bool mode = true) { m_respawnCompatibilityMode = mode; }
        bool GetRespawnCompatibilityMode() { return m_respawnCompatibilityMode; }

        // Handling caster facing during spellcast
        void SetTarget(ObjectGuid guid) override;
        void MustReacquireTarget() { m_shouldReacquireTarget = true; } // flags the Creature for forced (client displayed) target reacquisition in the next ::Update call
        void DoNotReacquireTarget() { m_shouldReacquireTarget = false; m_suppressedTarget = ObjectGuid::Empty; m_suppressedOrientation = 0.0f; }
        void FocusTarget(Spell const* focusSpell, WorldObject const* target);
        bool IsFocusing(Spell const* focusSpell = nullptr, bool withDelay = false) override;
        void ReleaseFocus(Spell const* focusSpell, bool withDelay = true);

        bool IsMovementPreventedByCasting() const override;

        CreatureTextRepeatIds GetTextRepeatGroup(uint8 textGroup);
        void SetTextRepeatId(uint8 textGroup, uint8 id);
        void ClearTextRepeatGroup(uint8 textGroup);

        void SetCannotReachTarget(bool cannotReach);
        bool CannotReachTarget() const;
        bool IsEvadingAttacks() const { return m_evadingAttacks || IsInEvadeMode(); }
        //
        void HandleUnreachableTarget(uint32 diff);

        /**
        Same as SetKeepActive but with a timer, disable it after given time in MS
        */
        void SetKeepActiveTimer(uint32 timerMS);

        bool IsEscortNPC(bool onlyIfActive = true) const;

        bool CanGiveExperience() const;

        void AtEnterCombat() override;
        void AtExitCombat() override;

        std::string GetDebugInfo() const override;

    protected:
        bool CreateFromProto(ObjectGuid::LowType guidlow, uint32 Entry, const CreatureData *data = nullptr);
        bool InitEntry(uint32 entry, const CreatureData* data = nullptr);

		bool IsInvisibleDueToDespawn() const override;
		bool CanAlwaysSee(WorldObject const* obj) const override;

        // vendor items
        VendorItemCounts m_vendorItemCounts;

        uint32 m_lootMoney;
        ObjectGuid m_lootRecipient;
        uint32 m_lootRecipientGroup; //group identified by leader

        /* This is only filled for worldbosses with every players with threat > 0  */
        std::set<uint32> m_playerInThreatListAtDeath;

        /// Timers
        time_t _pickpocketLootRestore;
        uint32 m_corpseRemoveTime;                          // (msecs)timer for death or corpse disappearance
        time_t m_respawnTime;                               // (secs) time of next respawn
        uint32 m_respawnDelay;                              // (secs) delay between corpse disappearance and respawning
        uint32 m_corpseDelay;                               // (secs) delay between death and corpse disappearance
        float m_respawnradius;
        uint32 m_boundaryCheckTime;                         // (msecs) remaining time for next evade boundary check
        uint32 m_combatPulseTime;                           // (msecs) remaining time for next zone-in-combat pulse
        uint32 m_combatPulseDelay;                          // (secs) how often the creature puts the entire zone in combat (only works in dungeons)

        ReactStates m_reactState;                           // for AI, not charmInfo
        void RegenerateHealth();
        void Regenerate(Powers power);
        uint32 m_areaCombatTimer;
        void AreaCombat();
        MovementGeneratorType m_defaultMovementType;
        ObjectGuid::LowType m_spawnId;                               /// For new or temporary creatures is 0 for saved it is lowguid
        uint32 m_equipmentId;
        int8 m_originalEquipmentId; // can be -1

        bool m_AlreadyCallAssistance;
        bool m_regenHealth;

        SpellSchoolMask m_meleeDamageSchoolMask;
        uint32 m_originalEntry;

        Position m_homePosition;
        Position m_transportHomePosition;

        bool disableReputationGain;
        
        uint64 m_timeSinceSpawn;                            // (msecs) elapsed time since (re)spawn
        
        // Time since target is unreachable
        uint32 m_unreachableTargetTime;
        // Creature evade all attacks. This is different from evade mode, when target is unreachable creature will stay some tile on place before evading.
        bool m_evadingAttacks;

        Position m_lastMovementFlagsPosition;

        bool m_canFly; //create is able to fly. Not directly related to the CAN_FLY moveflags. Yes this is all confusing.

        uint32 m_stealthAlertCooldown;
        uint32 m_keepActiveTimer;

    private:
        void ForcedDespawn(uint32 timeMSToDespawn = 0, Seconds forceRespawnTimer = Seconds(0));

        // Waypoint path
        uint32 _waypointPathId;
        std::pair<uint32/*nodeId*/, uint32/*pathId*/> _currentWaypointNodeInfo;

        //Formation var
        CreatureGroup *m_formation;
        bool m_triggerJustAppeared;
        bool m_respawnCompatibilityMode;

        CreatureTemplate const* m_creatureInfo;                 // in heroic mode can different from ObjectMgr::GetCreatureTemplate(GetEntry())
        CreatureData const* m_creatureData;

        time_t m_lastDamagedTime; // Part of Evade mechanic

        uint16 m_LootMode;                                  // Bitmask (default: LOOT_MODE_DEFAULT) that determines what loot will be lootable

        /* Spell focus system */
        Spell const* m_focusSpell;   // Locks the target during spell cast for proper facing
        uint32 m_focusDelay;
        bool m_shouldReacquireTarget;
        ObjectGuid m_suppressedTarget; // Stores the creature's "real" target while casting
        float m_suppressedOrientation; // Stores the creature's "real" orientation while casting

        CreatureTextRepeatGroup m_textRepeat;
};

class TC_GAME_API AssistDelayEvent : public BasicEvent
{
    public:
        AssistDelayEvent(ObjectGuid victim, Unit& owner) : BasicEvent(), m_victim(victim), m_owner(owner) { }

        bool Execute(uint64 e_time, uint32 p_time) override;
        void AddAssistant(ObjectGuid guid) { m_assistants.push_back(guid); }
    private:
        AssistDelayEvent();

        ObjectGuid            m_victim;
        std::list<ObjectGuid> m_assistants;
        Unit&                 m_owner;
};

class TC_GAME_API ForcedDespawnDelayEvent : public BasicEvent
{
    public:
        ForcedDespawnDelayEvent(Creature& owner, Seconds const& respawnTimer) : BasicEvent(), m_owner(owner), m_respawnTimer(respawnTimer) { }
        bool Execute(uint64 e_time, uint32 p_time) override;

    private:
        Creature& m_owner;
        Seconds const m_respawnTimer;
};

class TC_GAME_API AIMessageEvent : public BasicEvent
{
public:
    AIMessageEvent(Creature& owner, uint32 id, uint64 data = 0) : 
        owner(owner),
        id(id),
        data(data)
    {}

    bool Execute(uint64 /*e_time*/, uint32 /*p_time*/) override;

private:
    Creature& owner;
    uint32 id;
    uint64 data;
};

#endif

