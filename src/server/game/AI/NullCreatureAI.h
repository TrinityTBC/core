
#ifndef TRINITY_NULLCREATUREAI_H
#define TRINITY_NULLCREATUREAI_H

#include "CreatureAI.h"

class TC_GAME_API PassiveAI : public CreatureAI
{
    public:
        PassiveAI(Creature *c) : CreatureAI(c) {}
        ~PassiveAI() override {}

        void MoveInLineOfSight(Unit *) override {}
        void AttackStart(Unit *) override {}

        void UpdateAI(uint32) override;

        static int32 Permissible(Creature const* /*creature*/) { return PERMIT_BASE_NO; }
};

class TC_GAME_API PossessedAI : public PassiveAI
{
    public:
        PossessedAI(Creature *c) : PassiveAI(c) {}

        void AttackStart(Unit *target) override;
        void JustEnteredCombat(Unit* who) override { EngagementStart(who); }
        void JustExitedCombat() override { EngagementOver(); }
        void JustStartedThreateningMe(Unit*) override { }
        void UpdateAI(uint32) override;
        void EnterEvadeMode(EvadeReason /* why */) override {}

        void JustDied(Unit*) override;
        void KilledUnit(Unit* victim) override;

        static int32 Permissible(Creature const* /*creature*/) { return PERMIT_BASE_NO; }
};

class TC_GAME_API NullCreatureAI : public PassiveAI
{
    public:
        NullCreatureAI(Creature *c) : PassiveAI(c) {}

        void MoveInLineOfSight(Unit*) override { }
        void AttackStart(Unit*) override { }
        void JustStartedThreateningMe(Unit*) override { }
        void JustEnteredCombat(Unit*) override { }
        void UpdateAI(uint32) override {}
        void EnterEvadeMode(EvadeReason /* why */) override {}
        void OnCharmed(bool /*isNew*/) override { }

        static int32 Permissible(Creature const* creature);
};

class TC_GAME_API CritterAI : public PassiveAI
{
    public:
        CritterAI(Creature *c) : PassiveAI(c) {}

        void DamageTaken(Unit *done_by, uint32 & /*damage*/) override;
        void EnterEvadeMode(EvadeReason /* why */) override;

        static int32 Permissible(Creature const* creature);
};

#endif

