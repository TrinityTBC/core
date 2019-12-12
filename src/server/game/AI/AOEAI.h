
#ifndef TRINITY_AOEAI_H
#define TRINITY_AOEAI_H

#include "CreatureAI.h"

class Creature;

struct AOEAI : public CreatureAI
{
    public:
        explicit AOEAI(Creature *c);
        void AttackStart(Unit *who) override;
        void UpdateAI(uint32 diff) override;

        static int Permissible(const Creature *);
};

#endif
