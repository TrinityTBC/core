#ifndef TRINITY_ARCHERAI_H
#define TRINITY_ARCHERAI_H

#include "CreatureAI.h"

class Creature;

struct ArcherAI : public CreatureAI
{
    public:
        explicit ArcherAI(Creature *c);
        void AttackStart(Unit *who);
        void UpdateAI(uint32 diff) override;

        static int Permissible(const Creature *);
        
    private:
        float m_minRange;
};

#endif
