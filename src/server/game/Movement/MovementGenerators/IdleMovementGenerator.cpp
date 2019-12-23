
#include "IdleMovementGenerator.h"
#include "CreatureAI.h"
#include "Creature.h"
#include "MovementDefines.h"

IdleMovementGenerator::IdleMovementGenerator()
{
    Mode = MOTION_MODE_DEFAULT;
    Priority = MOTION_PRIORITY_NORMAL;
    Flags = MOVEMENTGENERATOR_FLAG_INITIALIZED;
    BaseUnitState = 0;
}

/*
 *  TODO: "if (!owner->IsStopped())" is useless, each generator cleans their own STATE_MOVE, the result is that StopMoving is almost never called
 *  Old comment: "StopMoving is needed to make unit stop if its last movement generator expires but it should not be sent otherwise there are many redundent packets"
 */
void IdleMovementGenerator::Initialize(Unit* owner)
{
    owner->StopMoving();
}

void IdleMovementGenerator::Reset(Unit* owner)
{
    owner->StopMoving();
}

void IdleMovementGenerator::Deactivate(Unit* /*owner*/)
{
}

void IdleMovementGenerator::Finalize(Unit* /*owner*/, bool/* active*/, bool/* movementInform*/)
{
    AddFlag(MOVEMENTGENERATOR_FLAG_FINALIZED);
}

MovementGeneratorType IdleMovementGenerator::GetMovementGeneratorType() const
{
    return IDLE_MOTION_TYPE;
}