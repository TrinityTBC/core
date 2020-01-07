
#ifndef TRINITY_GRIDNOTIFIERS_H
#define TRINITY_GRIDNOTIFIERS_H

#include "UpdateData.h"
#include <iostream>

#include "Creature.h"
#include "Corpse.h"
#include "CreatureAI.h"
#include "Object.h"
#include "DynamicObject.h"
#include "GameObject.h"
#include "Player.h"
#include "Unit.h"
#include "Spell.h"
#include "SpellInfo.h"

//class Map;

namespace Trinity
{
	struct TC_GAME_API VisibleNotifier
	{
		Player &i_player;
		UpdateData i_data;
		std::set<Unit*> i_visibleNow;
		GuidUnorderedSet vis_guids;

		VisibleNotifier(Player &player) : i_player(player), vis_guids(player.m_clientGUIDs) { }
		template<class T> void Visit(GridRefManager<T> &m);
		void SendToSelf(void);
	};

	struct VisibleChangesNotifier
	{
		WorldObject &i_object;

		explicit VisibleChangesNotifier(WorldObject &object) : i_object(object) { }
		template<class T> void Visit(GridRefManager<T> &) { }
		void Visit(PlayerMapType &);
		void Visit(CreatureMapType &);
		void Visit(DynamicObjectMapType &);
	};

    struct TC_GAME_API PlayerRelocationNotifier : public VisibleNotifier
    {
        PlayerRelocationNotifier(Player &player) : VisibleNotifier(player) {}

        template<class T> inline void Visit(GridRefManager<T> &m) { VisibleNotifier::Visit(m); }
		void Visit(CreatureMapType &);
		void Visit(PlayerMapType &);
    };

	struct TC_GAME_API CreatureRelocationNotifier
	{
		Creature &i_creature;
		CreatureRelocationNotifier(Creature &c) : i_creature(c) { }
		template<class T> void Visit(GridRefManager<T> &) { }
		void Visit(CreatureMapType &);
		void Visit(PlayerMapType &);
	};

	struct TC_GAME_API DelayedUnitRelocation
	{
		Map &i_map;
		Cell &cell;
		CellCoord &p;
		const float i_radius;
		DelayedUnitRelocation(Cell &c, CellCoord &pair, Map &map, float radius) :
			i_map(map), cell(c), p(pair), i_radius(radius) { }
		template<class T> void Visit(GridRefManager<T> &) { }
		void Visit(CreatureMapType &);
		void Visit(PlayerMapType   &);
	};

	struct TC_GAME_API AIRelocationNotifier
	{ 
		Unit &i_unit;
		bool isCreature;
		explicit AIRelocationNotifier(Unit &unit) : i_unit(unit), isCreature(unit.GetTypeId() == TYPEID_UNIT) { }
		template<class T> void Visit(GridRefManager<T> &) { }
		void Visit(CreatureMapType &);
	};

    struct GridUpdater
    {
        GridType &i_grid;
        uint32 i_timeDiff;
        GridUpdater(GridType &grid, uint32 diff) : i_grid(grid), i_timeDiff(diff) {}

        template<class T> void updateObjects(GridRefManager<T> &m)
        {
            for(typename GridRefManager<T>::iterator iter = m.begin(); iter != m.end(); ++iter)
                iter->GetSource()->Update(i_timeDiff);
        }

        void Visit(PlayerMapType &m) { updateObjects<Player>(m); }
        void Visit(CreatureMapType &m){ updateObjects<Creature>(m); }
        void Visit(GameObjectMapType &m) { updateObjects<GameObject>(m); }
        void Visit(DynamicObjectMapType &m) { updateObjects<DynamicObject>(m); }
        void Visit(CorpseMapType &m) { updateObjects<Corpse>(m); }
    };

	struct TC_GAME_API MessageDistDeliverer
	{
		WorldObject const* i_source;
		WorldPacket const* i_message;
		uint32 i_phaseMask;
		float i_distSq;
		Team team;
		Player const* skipped_receiver;
		MessageDistDeliverer(WorldObject const* src, WorldPacket const* msg, float dist, bool own_team_only = false, Player const* skipped = NULL)
			: i_source(src), i_message(msg), i_phaseMask(src->GetPhaseMask()), i_distSq(dist * dist)
			, team(Team(0))
			, skipped_receiver(skipped)
		{
			if (own_team_only)
				if (Player const* player = src->ToPlayer())
					team = Team(player->GetTeam());
		}
		void Visit(PlayerMapType &m);
		void Visit(CreatureMapType &m);
		void Visit(DynamicObjectMapType &m);
		template<class SKIP> void Visit(GridRefManager<SKIP> &) {}

		void SendPacket(Player* player)
		{
			// never send packet to self
			if (player == i_source || (team != Team(0) && Team(player->GetTeam()) != team) || skipped_receiver == player)
				return;

			if (!player->HaveAtClient(i_source))
				return;

			player->GetSession()->SendPacket(i_message);
		}
	};

    struct TC_GAME_API ObjectUpdater
    {
        uint32 i_timeDiff;
        explicit ObjectUpdater(const uint32 &diff) : i_timeDiff(diff) {}
        template<class T> void Visit(GridRefManager<T> &m);
        void Visit(PlayerMapType &) {}
        void Visit(CorpseMapType &) {}
        void Visit(CreatureMapType &);
    };

    // SEARCHERS & LIST SEARCHERS & WORKERS

    // WorldObject searchers & workers

    // Generic base class to insert elements into arbitrary containers using push_back
    template<typename Type>
    class ContainerInserter {
        using InserterType = void(*)(void*, Type&&);

        void* ref;
        InserterType inserter;

        // MSVC workaround
        template<typename T>
        static void InserterOf(void* ref, Type&& type)
        {
            static_cast<T*>(ref)->push_back(std::move(type));
        }

    protected:
        template<typename T>
        ContainerInserter(T& ref_) : ref(&ref_), inserter(&InserterOf<T>) { }

        void Insert(Type type)
        {
            inserter(ref, std::move(type));
        }
    };

    template<class Check>
    struct WorldObjectSearcher
    {
        uint32 i_mapTypeMask;
        uint32 i_phaseMask; //Not yet used
        WorldObject* &i_object;
        Check &i_check;

        WorldObjectSearcher(WorldObject const* searcher, WorldObject* & result, Check& check, uint32 mapTypeMask = GRID_MAP_TYPE_MASK_ALL) 
            : i_mapTypeMask(mapTypeMask), i_phaseMask(searcher->GetPhaseMask()), i_object(result),i_check(check) {}

        void Visit(GameObjectMapType &m);
        void Visit(PlayerMapType &m);
        void Visit(CreatureMapType &m);
        void Visit(CorpseMapType &m);
        void Visit(DynamicObjectMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) {}
    };

    template<class Check>
    struct WorldObjectLastSearcher
    {
        uint32 i_mapTypeMask;
        uint32 i_phaseMask;
        WorldObject* &i_object;
        Check &i_check;

        WorldObjectLastSearcher(WorldObject const* searcher, WorldObject* & result, Check& check, uint32 mapTypeMask = GRID_MAP_TYPE_MASK_ALL)
            : i_mapTypeMask(mapTypeMask), i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check) {}

        void Visit(GameObjectMapType &m);
        void Visit(PlayerMapType &m);
        void Visit(CreatureMapType &m);
        void Visit(CorpseMapType &m);
        void Visit(DynamicObjectMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) {}
    };

    template<class Check>
    struct WorldObjectListSearcher : ContainerInserter<WorldObject*>
    {
        uint32 i_mapTypeMask;
        uint32 i_phaseMask; //not used yet
        Check& i_check;

        template<typename Container>
        WorldObjectListSearcher(WorldObject const* searcher, Container& container, Check & check, uint32 mapTypeMask = GRID_MAP_TYPE_MASK_ALL) :
            ContainerInserter<WorldObject*>(container),
            i_phaseMask(searcher->GetPhaseMask()), i_check(check), i_mapTypeMask(mapTypeMask) {}

        void Visit(PlayerMapType &m);
        void Visit(CreatureMapType &m);
        void Visit(CorpseMapType &m);
        void Visit(GameObjectMapType &m);
        void Visit(DynamicObjectMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) {}
    };

    template<class Do>
    struct WorldObjectWorker
    {
        uint32 i_mapTypeMask;
        Do const& i_do;

        explicit WorldObjectWorker(WorldObject const* searcher, Do const& _do, uint32 mapTypeMask = GRID_MAP_TYPE_MASK_ALL) : 
            i_do(_do), i_mapTypeMask(mapTypeMask) {}

        void Visit(GameObjectMapType &m)
        {
            if (!(i_mapTypeMask & GRID_MAP_TYPE_MASK_GAMEOBJECT))
                return;
            for(auto & itr : m)
                i_do(itr.GetSource());
        }

        void Visit(PlayerMapType &m)
        {
            if (!(i_mapTypeMask & GRID_MAP_TYPE_MASK_PLAYER))
                return;
            for(auto & itr : m)
                i_do(itr.GetSource());
        }
        void Visit(CreatureMapType &m)
        {
            if (!(i_mapTypeMask & GRID_MAP_TYPE_MASK_CREATURE))
                return;
            for(auto & itr : m)
                i_do(itr.GetSource());
        }

        void Visit(CorpseMapType &m)
        {
            if (!(i_mapTypeMask & GRID_MAP_TYPE_MASK_CORPSE))
                return;
            for(auto & itr : m)
                i_do(itr.GetSource());
        }

        void Visit(DynamicObjectMapType &m)
        {
            if (!(i_mapTypeMask & GRID_MAP_TYPE_MASK_DYNAMICOBJECT))
                return;
            for(auto & itr : m)
                i_do(itr.GetSource());
        }

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) {}
    };

    // Gameobject searchers

    template<class Check>
    struct GameObjectSearcher
    {
        uint32 i_phaseMask;
        GameObject* &i_object;
        Check &i_check;

        GameObjectSearcher(WorldObject const* searcher, GameObject* & result, Check& check)
            : i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check) { }

        void Visit(GameObjectMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    // Last accepted by Check GO if any (Check can change requirements at each call)
    template<class Check>
    struct GameObjectLastSearcher
    {
        uint32 i_phaseMask;
        GameObject* &i_object;
        Check& i_check;

        GameObjectLastSearcher(WorldObject const* searcher, GameObject* & result, Check& check)
            : i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check) { }

        void Visit(GameObjectMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    template<class Check>
    struct GameObjectListSearcher : ContainerInserter<GameObject*>
    {
        uint32 i_phaseMask;
        Check& i_check;

        template<typename Container>
        GameObjectListSearcher(WorldObject const* searcher, Container& container, Check & check)
            : ContainerInserter<GameObject*>(container),
            i_phaseMask(searcher->GetPhaseMask()), i_check(check) { }

        void Visit(GameObjectMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    // Unit searchers

    // First accepted by Check Unit if any
    template<class Check>
    struct UnitSearcher
    {
		uint32 i_phaseMask;
        Unit* &i_object;
        Check & i_check;

        UnitSearcher(WorldObject const* searcher, Unit* & result, Check & check) : i_phaseMask(searcher->GetPhaseMask()), i_object(result),i_check(check) {}

        void Visit(CreatureMapType &m);
        void Visit(PlayerMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) {}
    };

    // Last accepted by Check Unit if any (Check can change requirements at each call)
    template<class Check>
    struct UnitLastSearcher
    {
        uint32 i_phaseMask;
        Unit* &i_object;
        Check & i_check;

        UnitLastSearcher(WorldObject const* searcher, Unit* & result, Check & check)
            : i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check) { }

        void Visit(CreatureMapType &m);
        void Visit(PlayerMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    // All accepted by Check units if any
    template<class Check>
    struct UnitListSearcher : ContainerInserter<Unit*>
    {
        uint32 i_phaseMask;
        Check& i_check;

        template<typename Container>
        UnitListSearcher(WorldObject const* searcher, Container& container, Check& check)
            : ContainerInserter<Unit*>(container),
              i_phaseMask(searcher->GetPhaseMask()), i_check(check) { }

        void Visit(PlayerMapType &m);
        void Visit(CreatureMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };
    
    template<class Check>
    struct PlayerListSearcher : ContainerInserter<Player*>
    {
        uint32 i_phaseMask;
        Check& i_check;

        template<typename Container>
        PlayerListSearcher(WorldObject const* searcher, Container& container, Check & check)
            : ContainerInserter<Player*>(container),
            i_phaseMask(searcher->GetPhaseMask()), i_check(check) { }

        template<typename Container>
        PlayerListSearcher(uint32 phaseMask, Container& container, Check & check)
            : ContainerInserter<Player*>(container),
            i_phaseMask(phaseMask), i_check(check) { }

        void Visit(PlayerMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    // Creature searchers

    template<class Check>
    struct CreatureSearcher
    {
        uint32 i_phaseMask;
        Creature* &i_object;
        Check & i_check;

        CreatureSearcher(WorldObject const* searcher, Creature* & result, Check & check)
            : i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check) { }

        void Visit(CreatureMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    // Last accepted by Check Creature if any (Check can change requirements at each call)
    template<class Check>
    struct CreatureLastSearcher
    {
        uint32 i_phaseMask;
        Creature* &i_object;
        Check & i_check;

        CreatureLastSearcher(WorldObject const* searcher, Creature* & result, Check & check)
            : i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check) { }

        void Visit(CreatureMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    template<class Check>
    struct CreatureListSearcher : ContainerInserter<Creature*>
    {
        uint32 i_phaseMask;
        Check& i_check;

        template<typename Container>
        CreatureListSearcher(WorldObject const* searcher, Container& container, Check & check)
            : ContainerInserter<Creature*>(container),
              i_phaseMask(searcher->GetPhaseMask()), i_check(check) { }

        void Visit(CreatureMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    //checker must have argument : Creature*, float& range
    template<class Check>
    struct CreatureListSearcherWithRange
    {
        std::list< std::pair<Creature*,float> > &i_objects;
        Check& i_check;

        CreatureListSearcherWithRange(WorldObject const* /* searcher */, std::list< std::pair<Creature*,float> > &objects, Check & check) : i_objects(objects), i_check(check) {}

        void Visit(CreatureMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) {}
    };

    // Player searchers

    template<class Check>
    struct PlayerSearcher
    {
        uint32 i_phaseMask;
        Player* &i_object;
        Check & i_check;

        PlayerSearcher(WorldObject const* searcher, Player* & result, Check & check)
            : i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check) { }

        void Visit(PlayerMapType &m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    template<class Check>
    struct PlayerLastSearcher
    {
        uint32 i_phaseMask;
        Player* &i_object;
        Check& i_check;

        PlayerLastSearcher(WorldObject const* searcher, Player*& result, Check& check) : i_phaseMask(searcher->GetPhaseMask()), i_object(result), i_check(check)
        {
        }

        void Visit(PlayerMapType& m);

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    template<class Do>
    struct PlayerWorker
    {
        Do& i_do;

        explicit PlayerWorker(Do& _do) : i_do(_do) {}

        void Visit(PlayerMapType &m)
        {
            for(auto & itr : m)
                i_do(itr.GetSource());
        }

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) {}
    };

    template<class Do>
    struct PlayerDistWorker
    {
        WorldObject const* i_searcher;
        float i_dist;
        Do& i_do;

        PlayerDistWorker(WorldObject const* searcher, float _dist, Do& _do)
            : i_searcher(searcher), i_dist(_dist), i_do(_do) { }

        void Visit(PlayerMapType &m)
        {
            for (auto & itr : m)
                if (itr.GetSource()->InSamePhase(i_searcher) && itr.GetSource()->IsWithinDistInMap(i_searcher, i_dist))
                    i_do(itr.GetSource());
        }

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };
    
    template<class Do>
    struct CreatureWorker
    {
        uint32 i_phaseMask;
        Do& i_do;

        CreatureWorker(WorldObject const* searcher, Do& _do)
            : i_phaseMask(searcher->GetPhaseMask()), i_do(_do) { }

        void Visit(CreatureMapType &m)
        {
            for (CreatureMapType::iterator itr = m.begin(); itr != m.end(); ++itr)
                if (itr->GetSource()->InSamePhase(i_phaseMask))
                    i_do(itr->GetSource());
        }

        template<class NOT_INTERESTED> void Visit(GridRefManager<NOT_INTERESTED> &) { }
    };

    // CHECKS && DO classes

    // WorldObject do classes

    class TC_GAME_API RespawnDo
    {
        public:
            RespawnDo() = default;
            void operator()(Creature* u) const;
            void operator()(GameObject* u) const;
            void operator()(WorldObject*) const {}
            void operator()(Corpse*) const {}
    };

    class TC_GAME_API FactionDo
    {
        public:
            FactionDo(uint32 id, uint32 f) : i_entry(id), i_faction(f) {}
            void operator()(Creature* u) const;
            void operator()(GameObject*) const {}
            void operator()(WorldObject*) const {}
            void operator()(Corpse*) const {}
        private:
            uint32 i_entry, i_faction;
    };
    
    // WorldObject check classes

    //UNIT SEARCHERS
    
    class TC_GAME_API CannibalizeObjectCheck
    {
        public:
            CannibalizeObjectCheck(Unit* funit, float range) : i_funit(funit), i_range(range) {}
            bool operator()(Player* u);
            bool operator()(Corpse* u);
            bool operator()(Creature* u);
            template<class NOT_INTERESTED> bool operator()(NOT_INTERESTED*) { return false; }
        private:
            Unit* const i_funit;
            float i_range;
    };

    class AnyUnfriendlyUnitInObjectRangeCheck
    {
        public:
            AnyUnfriendlyUnitInObjectRangeCheck(WorldObject const* obj, Unit const* funit, float range) : i_obj(obj), i_funit(funit), i_range(range) { }

            bool operator()(Unit* u) const
            {
                if (u->IsAlive() && i_obj->IsWithinDistInMap(u, i_range) && !i_funit->IsFriendlyTo(u))
                    return true;

                return false;
            }

        private:
            WorldObject const* i_obj;
            Unit const* i_funit;
            float i_range;
    };

    class AnyUnfriendlyAoEAttackableUnitInObjectRangeCheck
    {
        public:
            AnyUnfriendlyAoEAttackableUnitInObjectRangeCheck(WorldObject const* obj, Unit const* funit, float range) : i_obj(obj), i_funit(funit), i_range(range) {}
            bool operator()(Unit* u)
            {
                if (!u->IsAttackableByAOE())
                    return false;

                // From 2.1.0 Feral Charge ignored traps, from 2.3.0 Intercept and Charge started to do so too
                if (u->HasUnitState(UNIT_STATE_CHARGING))
                    return false;

                if (!i_obj->IsWithinDistInMap(u, i_range))
                    return false;

                if (i_funit->IsFriendlyTo(u))
                    return false;

                return true;
            }
        private:
            WorldObject const* i_obj;
            Unit const* i_funit;
            float i_range;
    };


    class AnyFriendlyUnitInObjectRangeCheck
    {
        public:
            AnyFriendlyUnitInObjectRangeCheck(WorldObject const* obj, Unit const* funit, float range, bool playerOnly = false, bool incOwnRadius = true, bool incTargetRadius = true)
                : i_obj(obj), i_funit(funit), i_range(range), i_playerOnly(playerOnly), i_incOwnRadius(incOwnRadius), i_incTargetRadius(incTargetRadius) { }
            
            bool operator()(Unit* u)
            {
                if (!u->IsAlive())
                    return false;

                float searchRadius = i_range;
                if (i_incOwnRadius)
                    searchRadius += i_obj->GetCombatReach();
                if (i_incTargetRadius)
                    searchRadius += u->GetCombatReach();

                if (!u->IsInMap(i_obj) || !u->InSamePhase(i_obj) || !u->IsWithinDoubleVerticalCylinder(i_obj, searchRadius, searchRadius))
                    return false;

                if (!i_funit->IsFriendlyTo(u) || i_funit->IsTotem()) //exclude totems from aoe
                    return false;

                return !i_playerOnly || u->GetTypeId() == TYPEID_PLAYER;
            }

        private:
            WorldObject const* i_obj;
            Unit const* i_funit;
            float i_range;
            bool i_playerOnly;
            bool i_incOwnRadius;
            bool i_incTargetRadius;
    };

    class AnyFriendlyUnitInObjectRangeCheckWithRangeReturned
    {
        public:
            AnyFriendlyUnitInObjectRangeCheckWithRangeReturned(WorldObject const* obj, Unit const* funit, float range, bool playerOnly = false) : i_obj(obj), i_funit(funit), i_range(range), i_playerOnly(playerOnly) {}
            bool operator()(Unit* u, float& range)
            {
                range = i_obj->GetDistance(u);
                if (u->IsAlive() && i_range > range && i_funit->IsFriendlyTo(u) && (!i_playerOnly || u->GetTypeId() == TYPEID_PLAYER) && !u->IsTotem())
                    return true;
                else
                    return false;
            }

        private:
            WorldObject const* i_obj;
            Unit const* i_funit;
            float i_range;
            bool i_playerOnly;
    };

    class NearestFriendlyUnitInObjectRangeCheck
    {
        public:
            NearestFriendlyUnitInObjectRangeCheck(WorldObject const* obj, Unit const* funit, float range, bool playerOnly = false, bool furthest = false) : i_obj(obj), i_funit(funit), i_range(range), i_minRange(0), i_playerOnly(playerOnly), i_furthest(furthest) {}
            bool operator()(Unit* u)
            {
                if (u->IsAlive() && i_obj->IsWithinDistInMap(u, i_range) && (!i_furthest || !i_obj->IsWithinDistInMap(u, i_minRange)) && i_funit->IsFriendlyTo(u) && (!i_playerOnly || u->GetTypeId() == TYPEID_PLAYER) && !u->IsTotem())
                {
                    if (!i_furthest)
                        i_range = i_obj->GetDistance(u);
                    else
                        i_minRange = i_obj->GetDistance(u);
                    return true;
                }

                return false;
            }

        private:
            WorldObject const* i_obj;
            Unit const* i_funit;
            float i_range, i_minRange;
            bool i_playerOnly, i_furthest;
    };
    
    class AnyGroupedUnitInObjectRangeCheck
    {
    public:
        AnyGroupedUnitInObjectRangeCheck(WorldObject const* obj, Unit const* funit, float range, bool raid, bool playerOnly = false, bool incOwnRadius = true, bool incTargetRadius = true)
            : _source(obj), _refUnit(funit), _range(range), _raid(raid), _playerOnly(playerOnly), i_incOwnRadius(incOwnRadius), i_incTargetRadius(incTargetRadius) { }

        bool operator()(Unit* u) const
        {
            if (_playerOnly && u->GetTypeId() != TYPEID_PLAYER)
                return false;

            if (_raid)
            {
                if (!_refUnit->IsInRaidWith(u))
                    return false;
            }
            else if (!_refUnit->IsInPartyWith(u))
                return false;

            if (_refUnit->IsHostileTo(u))
                return false;

            if (!u->IsAlive() || u->IsTotem()) //exclude totems
                return false;

            float searchRadius = _range;
            if (i_incOwnRadius)
                searchRadius += _source->GetCombatReach();
            if (i_incTargetRadius)
                searchRadius += u->GetCombatReach();

            return u->IsInMap(_source) && u->InSamePhase(_source) && u->IsWithinDoubleVerticalCylinder(_source, searchRadius, searchRadius);
        }

    private:
        WorldObject const* _source;
        Unit const* _refUnit;
        float _range;
        bool _raid;
        bool _playerOnly;
        bool i_incOwnRadius;
        bool i_incTargetRadius;
    };

    class AnyUnitInObjectRangeCheck
    {
        public:
            AnyUnitInObjectRangeCheck(WorldObject const* obj, float range) : i_obj(obj), i_range(range) {}
            bool operator()(Unit* u)
            {
                if (u->IsAlive() && i_obj->IsWithinDistInMap(u, i_range))
                    return true;

                return false;
            }

        private:
            WorldObject const* i_obj;
            float i_range;
    };

    // Success at unit in range, range update for next check (this can be use with UnitLastSearcher to find nearest unit)
    class NearestAttackableUnitInObjectRangeCheck
    {
        public:
            NearestAttackableUnitInObjectRangeCheck(WorldObject const* obj, Unit const* funit, float range) : i_obj(obj), i_funit(funit), i_range(range) {}
            bool operator()(Unit* u)
            {
                if (i_funit->IsValidAttackTarget(u) && i_obj->IsWithinDistInMap(u, i_range) &&
                    (i_funit->IsInCombatWith(u) || i_funit->IsHostileTo(u)) && i_obj->CanSeeOrDetect(u))
                {
                    i_range = i_obj->GetDistance(u);        // use found unit range as new range limit for next check
                    return true;
                }

                return false;
            }

        private:
            WorldObject const* i_obj;
            Unit const* i_funit;
            float i_range;

            // prevent clone this object
            NearestAttackableUnitInObjectRangeCheck(NearestAttackableUnitInObjectRangeCheck const&) = delete;
            NearestAttackableUnitInObjectRangeCheck& operator=(NearestAttackableUnitInObjectRangeCheck const &_Right) = delete;
    };

    class AnyAoETargetUnitInObjectRangeCheck
    {
        public:
            AnyAoETargetUnitInObjectRangeCheck(WorldObject const* obj, Unit const* funit, float range, SpellInfo const* spellInfo = nullptr, bool incOwnRadius = true, bool incTargetRadius = true)
                : i_obj(obj), i_funit(funit), _spellInfo(spellInfo), i_range(range), i_incOwnRadius(incOwnRadius), i_incTargetRadius(incTargetRadius)
            {
            }

            bool operator()(Unit* u) const
            {
                // Check contains checks for: live, non-selectable, non-attackable flags, flight check and GM check, ignore totems
                if (u->GetTypeId() == TYPEID_UNIT && u->IsTotem())
                    return false;

                if (_spellInfo && _spellInfo->HasAttribute(SPELL_ATTR3_ONLY_TARGET_PLAYERS) && u->GetTypeId() != TYPEID_PLAYER)
                    return false;

                if (!i_funit->IsValidAttackTarget(u, _spellInfo))
                    return false;

                float searchRadius = i_range;
                if (i_incOwnRadius)
                    searchRadius += i_obj->GetCombatReach();
                if (i_incTargetRadius)
                    searchRadius += u->GetCombatReach();

                return u->IsInMap(i_obj) && u->InSamePhase(i_obj) && u->IsWithinDoubleVerticalCylinder(i_obj, searchRadius, searchRadius);
            }

        private:
            WorldObject const* i_obj;
            Unit const* i_funit;
            SpellInfo const* _spellInfo;
            float i_range;
            bool i_incOwnRadius;
            bool i_incTargetRadius;
    };

    // do attack at call of help to friendly creature
    class CallOfHelpCreatureInRangeDo
    {
        public:
            CallOfHelpCreatureInRangeDo(Unit* funit, Unit* enemy, float range)
                : i_funit(funit), i_enemy(enemy), i_range(range) { }

            void operator()(Creature* u) const
            {
                if (u == i_funit)
                    return;

                if (!u->CanAssistTo(i_funit, i_enemy, false))
                    return;

                // too far
                if (!u->IsWithinDistInMap(i_funit, i_range))
                    return;

                // only if see assisted creature's enemy
                if (!u->IsWithinLOSInMap(i_enemy))
                    return;

                u->EngageWithTarget(i_enemy);
            }
        private:
            Unit* const i_funit;
            Unit* const i_enemy;
            float i_range;
    };

    struct AnyDeadUnitCheck
    {
        bool operator()(Unit* u)
        {
            return !u->IsAlive();
        }
    };

    class UnitAuraCheck
    {
    public:
        UnitAuraCheck(bool present, uint32 spellId, ObjectGuid casterGUID = ObjectGuid::Empty) : _present(present), _spellId(spellId), _casterGUID(casterGUID) { }

        bool operator()(Unit* unit) const
        {
            return unit->HasAura(_spellId, _casterGUID) == _present;
        }

        bool operator()(WorldObject* object) const
        {
            return object->ToUnit() && object->ToUnit()->HasAura(_spellId, _casterGUID) == _present;
        }

    private:
        bool _present;
        uint32 _spellId;
        ObjectGuid _casterGUID;
    };

    // Creature checks

    class NearestHostileUnitCheck
    {
    public:
        explicit NearestHostileUnitCheck(Creature const* creature, float dist = 0.f, bool playerOnly = false) : me(creature), i_playerOnly(playerOnly)
        {
            m_range = (dist == 0.f ? 9999.f : dist);
        }

        bool operator()(Unit* u)
        {
            if (u == me)
                return false;

            if (i_playerOnly && u->GetTypeId() != TYPEID_PLAYER)
                return false;

            if (!me->IsWithinDistInMap(u, m_range))
                return false;

            if (!me->IsValidAttackTarget(u))
                return false;

            m_range = me->GetDistance(u);   // use found unit range as new range limit for next check
            return true;
        }

    private:
        Creature const* me;
        float m_range;
        bool i_playerOnly;
        NearestHostileUnitCheck(NearestHostileUnitCheck const&) = delete;
    };

    class NearestHostileUnitInAttackDistanceCheck
    {
        public:
            explicit NearestHostileUnitInAttackDistanceCheck(Creature const* creature, float dist = 0, bool playerOnly = false, bool furthest = false) : me(creature), i_playerOnly(playerOnly), m_minRange(0), i_furthest(furthest)
            {
                m_range = (dist == 0 ? 9999 : dist);
                m_force = (dist == 0 ? false : true);
            }
            bool operator()(Unit* u)
            {
                if (u == me)
                    return false;

                if (i_playerOnly && u->GetTypeId() != TYPEID_PLAYER)
                    return false;

                if (!me->CanSeeOrDetect(u))
                    return false;

                if (m_force)
                {
                    if (!me->IsValidAttackTarget(u))
                        return false;
                }
                else  if (!me->CanAggro(u))
                    return false;

                //is in range
                if (!me->IsWithinDistInMap(u, m_range))
                    return false;

                //check for furthest if set
                if (i_furthest)
                {
                    if (me->IsWithinDistInMap(u, m_minRange))
                        return false;
                    else
                        m_minRange = me->GetDistance(u);
                }
                else { //else we want the nearest, then set new max range
                    m_range = me->GetDistance(u);
                }

                return true;
            }

            float GetLastRange() const { return m_range; }
        private:
            Creature const* me;
            float m_range, m_minRange;
            bool m_force;
            bool i_playerOnly;
            bool i_furthest;
            NearestHostileUnitInAttackDistanceCheck(NearestHostileUnitInAttackDistanceCheck const&) = delete;
    };

    class NearestHostileUnitInAggroRangeCheck
    {
    public:
        explicit NearestHostileUnitInAggroRangeCheck(Creature const* creature, bool useLOS = false) : _me(creature), _useLOS(useLOS) { }

        bool operator()(Unit* u) const
        {
            if (!u->IsHostileTo(_me))
                return false;

            if (!u->IsWithinDistInMap(_me, _me->GetAggroRange(u)))
                return false;

            if (!_me->IsValidAttackTarget(u))
                return false;

            if (_useLOS && !u->IsWithinLOSInMap(_me))
                return false;

            return true;
        }

    private:
        Creature const* _me;
        bool _useLOS;
        NearestHostileUnitInAggroRangeCheck(NearestHostileUnitInAggroRangeCheck const&) = delete;
    };

	class GameObjectInRangeCheck
	{
	public:
		GameObjectInRangeCheck(float _x, float _y, float _z, float _range, uint32 _entry = 0) : x(_x), y(_y), z(_z), range(_range), entry(_entry) { }

		bool operator()(GameObject* go) const
		{
			if (!entry || (go->GetGOInfo() && go->GetGOInfo()->entry == entry))
				return go->IsInRange(x, y, z, range);
			else return false;
		}

	private:
		float x, y, z, range;
		uint32 entry;
	};

    class AllWorldObjectsInRange
    {
        public:
            AllWorldObjectsInRange(const WorldObject* pObject, float fMaxRange) : m_pObject(pObject), m_fRange(fMaxRange) {}
            bool operator() (WorldObject* pGo)
            {
                return m_pObject->IsWithinDist(pGo, m_fRange, false) && m_pObject->InSamePhase(pGo);
            }

        private:
            const WorldObject* m_pObject;
            float m_fRange;
    };
    
    class ObjectGUIDCheck
    {
    public:
        ObjectGUIDCheck(ObjectGuid GUID, bool equals) : _GUID(GUID), _equals(equals) {}
        bool operator()(WorldObject const* object)
        {
            return (object->GetGUID() == _GUID) == _equals;
        }

    private:
        ObjectGuid _GUID;
        bool _equals;
    };

    class MostHPMissingInRange
    {
    public:
        MostHPMissingInRange(Unit const* obj, float range, uint32 hp) : i_obj(obj), i_range(range), i_hp(hp) {}
        bool operator()(Unit* u)
        {
            if (u->IsAlive() 
                && u->IsInCombat() 
                && !i_obj->IsHostileTo(u) 
                && i_obj->IsWithinDistInMap(u, i_range) 
                && u->GetMaxHealth() - u->GetHealth() > i_hp
            )
            {
                i_hp = u->GetMaxHealth() - u->GetHealth();
                return true;
            }
            return false;
        }

    private:
        Unit const* i_obj;
        float i_range;
        uint32 i_hp;
    };

    class FriendlyCCedInRange
    {
    public:
        FriendlyCCedInRange(Unit const* obj, float range) : i_obj(obj), i_range(range) {}
        bool operator()(Unit* u)
        {
            if (u->IsAlive() 
                && u->IsInCombat() 
                && !i_obj->IsHostileTo(u) 
                && i_obj->IsWithinDistInMap(u, i_range) 
                && (u->IsFeared() || u->IsCharmed() || u->IsFrozen() || u->HasUnitState(UNIT_STATE_STUNNED) || u->HasUnitState(UNIT_STATE_CONFUSED))
            )
            {
                return true;
            }
            return false;
        }

    private:
        Unit const* i_obj;
        float i_range;
    };

    class FriendlyBelowHpPctEntryInRange
	{
	public:
		FriendlyBelowHpPctEntryInRange(Unit const* obj, uint32 entry, float range, uint8 pct, bool excludeSelf) : i_obj(obj), i_entry(entry), i_range(range), i_pct(pct), i_excludeSelf(excludeSelf) { }

		bool operator()(Unit* u)
		{
			if (i_excludeSelf && i_obj->GetGUID() == u->GetGUID())
				return false;
			if (u->GetEntry() == i_entry && u->IsAlive() && u->IsInCombat() && !i_obj->IsHostileTo(u) && i_obj->IsWithinDistInMap(u, i_range) && u->HealthBelowPct(i_pct))
				return true;
			return false;
		}

	private:
		Unit const* i_obj;
		uint32 i_entry;
		float i_range;
		uint8 i_pct;
		bool i_excludeSelf;
	};

    class FriendlyMissingBuffInRange
    {
    public:
        FriendlyMissingBuffInRange(Unit const* obj, float range, uint32 spellid) : i_obj(obj), i_range(range), i_spell(spellid) {}
        bool operator()(Unit* u)
        {
            if (u->IsAlive() 
                && u->IsInCombat() 
                && /*!i_obj->IsHostileTo(u)*/ i_obj->IsFriendlyTo(u) 
                && i_obj->IsWithinDistInMap(u, i_range) 
                && !(u->HasAuraEffect(i_spell, 0) || u->HasAuraEffect(i_spell, 1) || u->HasAuraEffect(i_spell, 2))
            )
            {
                return true;
            }
            return false;
        }

    private:
        Unit const* i_obj;
        float i_range;
        uint32 i_spell;
    };
    
    class FriendlyMissingBuffInRangeOutOfCombat
    {
    public:
        FriendlyMissingBuffInRangeOutOfCombat(Unit const* obj, float range, uint32 spellid) : i_obj(obj), i_range(range), i_spell(spellid) {}
        bool operator()(Unit* u)
        {
            if (u->IsAlive() 
                && !u->IsInCombat() 
                && i_obj->IsFriendlyTo(u) 
                && i_obj->IsWithinDistInMap(u, i_range) 
                && !(u->HasAura(i_spell)) 
                && i_obj != u
            )
            {
                return true;
            }
            return false;
        }

    private:
        Unit const* i_obj;
        float i_range;
        uint32 i_spell;
    };

    //PLAYERS SEARCHERS
    
    class AnyPlayerInObjectRangeCheck
    {
        public:
            AnyPlayerInObjectRangeCheck(WorldObject const* obj, float range, bool reqAlive = true) : _obj(obj), _range(range), _reqAlive(reqAlive) { }

            bool operator()(Player* u) const
            {
                if (_reqAlive && !u->IsAlive())
                    return false;

                if (!_obj->IsWithinDistInMap(u, _range))
                    return false;

                return true;
            }

        private:
            WorldObject const* _obj;
            float _range;
            bool _reqAlive;
    };

    class NearestPlayerInObjectRangeCheck
    {
    public:
        public:
            NearestPlayerInObjectRangeCheck(WorldObject const& obj, bool alive, float range)
                : i_obj(obj), i_alive(alive), i_range(range) {}

            bool operator()(Player* u)
            {
                if (u->IsAlive() == i_alive 
                    && !u->isSpectator() 
                    && i_obj.IsWithinDistInMap(u, i_range))
                {
                    i_range = i_obj.GetDistance(u);         // use found unit range as new range limit for next check
                    return true;
                }
                return false;
            }

            float GetLastRange() const { return i_range; }
        private:
            WorldObject const& i_obj;
            bool   i_alive;
            float  i_range;

            // prevent clone this object
            NearestPlayerInObjectRangeCheck(NearestPlayerInObjectRangeCheck const&);
    };

    // Prepare using Builder localized packets with caching and send to player
    template<class Builder>
    class LocalizedPacketDo
    {
        public:
            explicit LocalizedPacketDo(Builder& builder) : i_builder(builder) { }

            ~LocalizedPacketDo()
            {
                for (size_t i = 0; i < i_data_cache.size(); ++i)
                    delete i_data_cache[i];
            }
            void operator()(Player* p);

        private:
            Builder& i_builder;
            std::vector<WorldPacket*> i_data_cache;         // 0 = default, i => i-1 locale index
    };

    // Prepare using Builder localized packets with caching and send to player
    template<class Builder>
    class LocalizedPacketListDo
    {
        public:
            typedef std::vector<WorldPacket*> WorldPacketList;
            explicit LocalizedPacketListDo(Builder& builder) : i_builder(builder) { }

            ~LocalizedPacketListDo()
            {
                for (size_t i = 0; i < i_data_cache.size(); ++i)
                    for (size_t j = 0; j < i_data_cache[i].size(); ++j)
                        delete i_data_cache[i][j];
            }
            void operator()(Player* p);

        private:
            Builder& i_builder;
            std::vector<WorldPacketList> i_data_cache;
                                                            // 0 = default, i => i-1 locale index
    };

    //CREATURES SEARCHERS

    class AllFriendlyCreaturesInGrid
    {
    public:
        AllFriendlyCreaturesInGrid(Unit const* obj) : pUnit(obj) {}
        bool operator() (Creature* u)
        {
            if (u->IsAlive() 
                && u->IsVisible() 
                && u->IsFriendlyTo(pUnit))
                return true;

            return false;
        }

    private:
        Unit const* pUnit;
    };

    // Success at unit in range, range update for next check (this can be use with CreatureLastSearcher to find nearest creature)
    class NearestCreatureEntryWithLiveStateInObjectRangeCheck
    {
        public:
            NearestCreatureEntryWithLiveStateInObjectRangeCheck(WorldObject const& obj,uint32 entry, bool alive, float range)
                : i_obj(obj), i_entry(entry), i_alive(alive), i_range(range) {}

            bool operator()(Creature* u)
            {
                if (u->GetEntry() == i_entry 
                    && u->IsAlive() == i_alive 
                    && i_obj.IsWithinDistInMap(u, i_range))
                {
                    i_range = i_obj.GetDistance(u);         // use found unit range as new range limit for next check
                    return true;
                }
                return false;
            }

            float GetLastRange() const { return i_range; }
        private:
            WorldObject const& i_obj;
            uint32 i_entry;
            bool   i_alive;
            float  i_range;

            // prevent clone this object
            NearestCreatureEntryWithLiveStateInObjectRangeCheck(NearestCreatureEntryWithLiveStateInObjectRangeCheck const&);
    };

    class AllCreaturesOfEntryInRange
    {
    public:
        AllCreaturesOfEntryInRange(WorldObject const* object, uint32 entry, float maxRange = 0.0f) : m_pObject(object), m_uiEntry(entry), m_fRange(maxRange) { }

        bool operator()(Unit* unit) const
        {
            if (m_uiEntry)
            {
                if (unit->GetEntry() != m_uiEntry)
                    return false;
            }

            if (m_fRange)
            {
                if (m_fRange > 0.0f && !m_pObject->IsWithinDist(unit, m_fRange, false))
                    return false;
                if (m_fRange < 0.0f && m_pObject->IsWithinDist(unit, m_fRange, false))
                    return false;
            }

            return true;
        }


    private:
        WorldObject const* m_pObject;
        uint32 m_uiEntry;
        float m_fRange;
    };

    class AllCreaturesInRange
    {
    public:
        AllCreaturesInRange(Unit const* obj, float ran) : pUnit(obj), range(ran) {}
        bool operator() (Creature* u)
        {
            if (pUnit->IsWithinDistInMap(u, range))
                return true;

            return false;
        }

    private:
        Unit const* pUnit;
        float range;
    };

    class AllCreatures
    {
    public:
        AllCreatures(Unit const* obj) : pUnit(obj) {}
        bool operator() (Creature* u)
        {
            return true;
        }

    private:
        Unit const* pUnit;
    };

    class AnyAssistCreatureInRangeCheck
    {
        public:
            AnyAssistCreatureInRangeCheck(Unit* funit, Unit* enemy, float range)
                : i_funit(funit), i_enemy(enemy), i_range(range)
            {
            }

            bool operator()(Creature* u)
            {
                if (u == i_funit)
                    return false;

                if (!u->CanAssistTo(i_funit, i_enemy))
                    return false;

                // too far
                if (!i_funit->IsWithinDistInMap(u, i_range, true))
                    return false;

                // only if see assisted creature
                if (!i_funit->IsWithinLOSInMap(u, LINEOFSIGHT_ALL_CHECKS, VMAP::ModelIgnoreFlags::M2))
                    return false;

                return true;
            }

        private:
            Unit* const i_funit;
            Unit* const i_enemy;
            float i_range;
    };

    class NearestAssistCreatureInCreatureRangeCheck
    {
        public:
            NearestAssistCreatureInCreatureRangeCheck(Creature* obj,Unit* enemy, float range)
                : i_obj(obj), i_enemy(enemy), i_range(range) {}

            bool operator()(Creature* u)
            {
                if (u->GetFaction() == i_obj->GetFaction() 
                    && !u->IsInCombat() 
                    && !u->GetCharmerOrOwnerGUID() 
                    && u->IsHostileTo(i_enemy) 
                    && u->IsAlive() 
                    && i_obj->IsWithinDistInMap(u, i_range) 
                    && i_obj->IsWithinLOSInMap(u, LINEOFSIGHT_ALL_CHECKS, VMAP::ModelIgnoreFlags::M2))
                {
                    i_range = i_obj->GetDistance(u);         // use found unit range as new range limit for next check
                    return true;
                }
                return false;
            }

            float GetLastRange() const { return i_range; }
        private:
            Creature* const i_obj;
            Unit* const i_enemy;
            float  i_range;

            // prevent clone this object
            NearestAssistCreatureInCreatureRangeCheck(NearestAssistCreatureInCreatureRangeCheck const&) = delete;
            NearestAssistCreatureInCreatureRangeCheck& operator=(NearestAssistCreatureInCreatureRangeCheck const &_Right) = delete;
    };

    class NearestGeneralizedAssistCreatureInCreatureRangeCheck
    {
        public:
            NearestGeneralizedAssistCreatureInCreatureRangeCheck(Creature* obj, uint32 entry, uint32 faction, float range)
                : i_obj(obj), i_entry(entry), i_faction(faction), i_range(range) {}

            bool operator()(Creature* u)
            {
                if (u->GetEntry() == i_entry 
                    && u->GetFaction() == i_faction 
                    && !u->IsInCombat() 
                    && !u->GetCharmerOrOwnerGUID() 
                    && u->IsAlive() 
                    && i_obj->IsWithinDistInMap(u, i_range) 
                    && i_obj->IsWithinLOSInMap(u, LINEOFSIGHT_ALL_CHECKS, VMAP::ModelIgnoreFlags::M2))
                {
                    i_range = i_obj->GetDistance(u);         // use found unit range as new range limit for next check
                    return true;
                }
                return false;
            }

            float GetLastRange() const { return i_range; }
        private:
            Creature* const i_obj;
            uint32 i_entry;
        uint32 i_faction;
            float  i_range;

            // prevent cloning this object
            NearestGeneralizedAssistCreatureInCreatureRangeCheck(NearestGeneralizedAssistCreatureInCreatureRangeCheck const&) = delete;
            NearestGeneralizedAssistCreatureInCreatureRangeCheck& operator=(NearestGeneralizedAssistCreatureInCreatureRangeCheck const &_Right) = delete;
    };



    //GOBJECT SEARCHERS

    class GameObjectFocusCheck
    {
        public:
            GameObjectFocusCheck(WorldObject const* caster, uint32 focusId) : _caster(caster), _focusId(focusId) {}
            bool operator()(GameObject* go) const
            {
                if (go->GetGOInfo()->type != GAMEOBJECT_TYPE_SPELL_FOCUS)
                    return false;

                if (go->GetGOInfo()->spellFocus.focusId != _focusId)
                    return false;

                float dist = (float)((go->GetGOInfo()->spellFocus.dist) / 2);

                return go->IsWithinDistInMap(_caster, dist);
            }

        private:
            WorldObject const* _caster;
            uint32 _focusId;
    };

    // Find the nearest Fishing hole and return true only if source object is in range of hole
    class NearestGameObjectFishingHole
    {
        public:
            NearestGameObjectFishingHole(WorldObject const& obj, float range) : i_obj(obj), i_range(range) {}
            bool operator()(GameObject* go)
            {
                if (go->GetGOInfo()->type == GAMEOBJECT_TYPE_FISHINGHOLE && go->isSpawned() && i_obj.IsWithinDistInMap(go, i_range) && i_obj.IsWithinDistInMap(go, go->GetGOInfo()->fishinghole.radius))
                {
                    i_range = i_obj.GetDistance(go);
                    return true;
                }
                return false;
            }

            float GetLastRange() const { return i_range; }
        private:
            WorldObject const& i_obj;
            float  i_range;

            // prevent clone
            NearestGameObjectFishingHole(NearestGameObjectFishingHole const&);
    };

    class NearestGameObjectCheck
    {
    public:
        NearestGameObjectCheck(WorldObject const& obj) : i_obj(obj), i_range(999.f) { }

        bool operator()(GameObject* go)
        {
            if (i_obj.IsWithinDistInMap(go, i_range))
            {
                i_range = i_obj.GetDistance(go);        // use found GO range as new range limit for next check
                return true;
            }
            return false;
        }

    private:
        WorldObject const& i_obj;
        float i_range;

        // prevent clone this object
        NearestGameObjectCheck(NearestGameObjectCheck const&) = delete;
    };

    class AllGameObjectsWithEntryInGrid
    {
    public:
        AllGameObjectsWithEntryInGrid(uint32 ent) : entry(ent) {}
        bool operator() (GameObject* g)
        {
            if (g->GetEntry() == entry)
                return true;

            return false;
        }

    private:
        uint32 entry;
    };
    
    class AllGameObjectsWithEntryInRange
    {
    public:
        AllGameObjectsWithEntryInRange(const WorldObject* pObject, uint32 uiEntry, float fMaxRange) : m_pObject(pObject), m_uiEntry(uiEntry), m_fRange(fMaxRange) {}
        bool operator() (GameObject* pGo)
        {
            if (pGo->GetEntry() == m_uiEntry 
                && m_pObject->IsWithinDistInMap(pGo, m_fRange, false))
                return true;

            return false;
        }

    private:
        const WorldObject* m_pObject;
        uint32 m_uiEntry;
        float m_fRange;
    };

    //2D check
    class AllGameObjectsInRange
    {
    public:
        AllGameObjectsInRange(float x, float y, float z, float fMaxRange) : m_X(x), m_Y(y), m_Z(z), m_fRange(fMaxRange) {}
        bool operator() (GameObject* pGo)
        {
            if (pGo->IsWithinDist3d(m_X, m_Y, m_Z, m_fRange))
                return true;

            return false;
        }

    private:
        float m_X;
        float m_Y;
        float m_Z;
        float m_fRange;
    };

    // Success at unit in range, range update for next check (this can be use with GameobjectLastSearcher to find nearest GO)
    class NearestGameObjectEntryInObjectRangeCheck
    {
        public:
            NearestGameObjectEntryInObjectRangeCheck(WorldObject const& obj,uint32 entry, float range) : i_obj(obj), i_entry(entry), i_range(range) {}
            bool operator()(GameObject* go)
            {
                if (go->GetEntry() == i_entry 
                    && i_obj.IsWithinDistInMap(go, i_range))
                {
                    i_range = i_obj.GetDistance(go);        // use found GO range as new range limit for next check
                    return true;
                }
                return false;
            }

            float GetLastRange() const { return i_range; }
        private:
            WorldObject const& i_obj;
            uint32 i_entry;
            float  i_range;

            // prevent clone this object
            NearestGameObjectEntryInObjectRangeCheck(NearestGameObjectEntryInObjectRangeCheck const&);
    };

    // Success at unit in range, range update for next check (this can be use with GameobjectLastSearcher to find nearest GO with a certain type)
    class NearestGameObjectTypeInObjectRangeCheck
    {
    public:
        NearestGameObjectTypeInObjectRangeCheck(WorldObject const& obj, GameobjectTypes type, float range) : i_obj(obj), i_type(type), i_range(range) {}
        bool operator()(GameObject* go)
        {
            if (go->GetGoType() == i_type && i_obj.IsWithinDistInMap(go, i_range))
            {
                i_range = i_obj.GetDistance(go);        // use found GO range as new range limit for next check
                return true;
            }
            return false;
        }
    private:
        WorldObject const& i_obj;
        GameobjectTypes i_type;
        float  i_range;

        // prevent clone this object
        NearestGameObjectTypeInObjectRangeCheck(NearestGameObjectTypeInObjectRangeCheck const&);
    };

    class GameObjectWithSpawnIdCheck
    {
        public:
            GameObjectWithSpawnIdCheck(WorldObject const& obj, ObjectGuid::LowType db_guid) : i_obj(obj), i_db_guid(db_guid) {}
            bool operator()(GameObject const* go) const
            {
                return go->GetSpawnId() == i_db_guid;
            }

        private:
            WorldObject const& i_obj;
            ObjectGuid::LowType i_db_guid;
    };
}
#endif
