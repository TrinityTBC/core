
#include "PointMovementGenerator.h"
#include "Errors.h"
#include "Creature.h"
#include "CreatureAI.h"
#include "World.h"
#include "MoveSplineInit.h"
#include "MoveSpline.h"
#include "Player.h"
#include "MotionMaster.h"
#include "MovementDefines.h"
#include "CreatureGroups.h"

template<class T>
PointMovementGenerator<T>::PointMovementGenerator(uint32 id, float x, float y, float z, bool generatePath, float speed, Optional<float> finalOrient) : _movementId(id), _x(x), _y(y), _z(z), _speed(speed), _generatePath(generatePath), _finalOrient(finalOrient)
{
    this->Mode = MOTION_MODE_DEFAULT;
    this->Priority = MOTION_PRIORITY_NORMAL;
    this->Flags = MOVEMENTGENERATOR_FLAG_INITIALIZATION_PENDING;
    this->BaseUnitState = UNIT_STATE_ROAMING;
}

template<class T>
void PointMovementGenerator<T>::LaunchMove(T* owner)
{
    Movement::MoveSplineInit init(owner);
    init.MoveTo(_x, _y, _z, _generatePath);
    if (_speed > 0.0f)
        init.SetVelocity(_speed);

    if (_finalOrient)
        init.SetFacing(*_finalOrient);

    init.Launch();

    // Call for creature group update
    if (Creature* creature = owner->ToCreature())
        creature->SignalFormationMovement(Position(_x, _y, _z), _movementId);
}

//----- Point Movement Generator
template<class T>
MovementGeneratorType PointMovementGenerator<T>::GetMovementGeneratorType() const
{
    return POINT_MOTION_TYPE;
}

template<class T>
void PointMovementGenerator<T>::DoInitialize(T* owner)
{
    MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_INITIALIZATION_PENDING | MOVEMENTGENERATOR_FLAG_DEACTIVATED | MOVEMENTGENERATOR_FLAG_TRANSITORY);
    MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_INITIALIZED);

    owner->AddUnitState(UNIT_STATE_ROAMING|UNIT_STATE_ROAMING_MOVE);

    if (_movementId == EVENT_CHARGE_PREPATH)
    {
        owner->AddUnitState(UNIT_STATE_ROAMING_MOVE);
        return;
    }

    //if cannot move : init generator but don't move for now
    if (owner->HasUnitState(UNIT_STATE_NOT_MOVE) || owner->IsMovementPreventedByCasting())
    {
        MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_INTERRUPTED);
        owner->StopMoving();
        return;
    }

    LaunchMove(owner);
}

template<class T>
bool PointMovementGenerator<T>::DoUpdate(T* owner, uint32 /*diff*/)
{
    if (!owner)
        return false;

    if (_movementId == EVENT_CHARGE_PREPATH)
    {
        if (owner->movespline->Finalized())
        {
            MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_INFORM_ENABLED);
            return false;
        }
        return true;
    }

    if (owner->HasUnitState(UNIT_STATE_NOT_MOVE) || owner->IsMovementPreventedByCasting())
    {
        MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_INTERRUPTED);
        owner->StopMoving();
        return true;
    }

    if ((MovementGenerator::HasFlag(MOVEMENTGENERATOR_FLAG_INTERRUPTED) && owner->movespline->Finalized()) || (MovementGenerator::HasFlag(MOVEMENTGENERATOR_FLAG_SPEED_UPDATE_PENDING) && !owner->movespline->Finalized()))
    {
        MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_INTERRUPTED | MOVEMENTGENERATOR_FLAG_SPEED_UPDATE_PENDING);
        owner->AddUnitState(UNIT_STATE_ROAMING_MOVE);
        LaunchMove(owner);
    }

    if (owner->movespline->Finalized())
    {
        MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_TRANSITORY);
        MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_INFORM_ENABLED);
        return false;
    }

    return true;
}

template<class T>
void PointMovementGenerator<T>::DoDeactivate(T* owner)
{
    MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_DEACTIVATED);
    owner->ClearUnitState(UNIT_STATE_ROAMING_MOVE);
}

template<class T>
void PointMovementGenerator<T>::DoFinalize(T* owner, bool active, bool movementInform)
{
    MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_FINALIZED);
    if (active)
        owner->ClearUnitState(UNIT_STATE_ROAMING_MOVE);

    if (movementInform && MovementGenerator::HasFlag(MOVEMENTGENERATOR_FLAG_INFORM_ENABLED))
        MovementInform(owner);
}

template<class T>
void PointMovementGenerator<T>::DoReset(T* owner)
{
    MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_TRANSITORY | MOVEMENTGENERATOR_FLAG_DEACTIVATED);

    if (!owner->IsStopped())
        owner->StopMoving();

    DoInitialize(owner);
}

template<class T>
void PointMovementGenerator<T>::MovementInform(T* /*unit*/) { }

template <> void PointMovementGenerator<Creature>::MovementInform(Creature* unit)
{
    if (unit->AI())
        unit->AI()->MovementInform(POINT_MOTION_TYPE, _movementId);
}

template PointMovementGenerator<Player>::PointMovementGenerator(uint32, float, float, float, bool, float, Optional<float>);
template PointMovementGenerator<Creature>::PointMovementGenerator(uint32, float, float, float, bool, float, Optional<float>);
template MovementGeneratorType PointMovementGenerator<Player>::GetMovementGeneratorType() const;
template MovementGeneratorType PointMovementGenerator<Creature>::GetMovementGeneratorType() const;
template void PointMovementGenerator<Player>::DoInitialize(Player*);
template void PointMovementGenerator<Creature>::DoInitialize(Creature*);
template void PointMovementGenerator<Player>::DoFinalize(Player*, bool, bool);
template void PointMovementGenerator<Creature>::DoFinalize(Creature*, bool, bool);
template void PointMovementGenerator<Player>::DoDeactivate(Player*);
template void PointMovementGenerator<Creature>::DoDeactivate(Creature*);
template void PointMovementGenerator<Player>::DoReset(Player*);
template void PointMovementGenerator<Creature>::DoReset(Creature*);
template bool PointMovementGenerator<Player>::DoUpdate(Player*, uint32);
template bool PointMovementGenerator<Creature>::DoUpdate(Creature*, uint32);

//---- AssistanceMovementGenerator
 	 
MovementGeneratorType AssistanceMovementGenerator::GetMovementGeneratorType() const
{
    return ASSISTANCE_MOTION_TYPE;
}

void AssistanceMovementGenerator::Initialize(Unit* owner)
{
    RemoveFlag(MOVEMENTGENERATOR_FLAG_INITIALIZATION_PENDING | MOVEMENTGENERATOR_FLAG_DEACTIVATED);
    AddFlag(MOVEMENTGENERATOR_FLAG_INITIALIZED);

    if (owner->HasUnitState(UNIT_STATE_LOST_CONTROL | UNIT_STATE_NOT_MOVE))
        return;

    if (!owner->IsStopped())
        owner->StopMoving();

    owner->AddUnitState(UNIT_STATE_ROAMING | UNIT_STATE_ROAMING_MOVE);
    Movement::MoveSplineInit init(owner);
    init.MoveTo(_x, _y, _z);
    init.SetVelocity(owner->GetSpeed(MOVE_RUN) * 0.66);
    init.Launch();
}

void AssistanceMovementGenerator::Finalize(Unit* owner, bool active, bool movementInform)
{
    AddFlag(MOVEMENTGENERATOR_FLAG_FINALIZED);
    if (active)
        owner->ClearUnitState(UNIT_STATE_ROAMING_MOVE);

    if (movementInform && HasFlag(MOVEMENTGENERATOR_FLAG_INFORM_ENABLED))
    {
        Creature* ownerCreature = owner->ToCreature();
        ownerCreature->SetNoCallAssistance(false);
        ownerCreature->CallAssistance();
        if (ownerCreature->IsAlive())
            ownerCreature->GetMotionMaster()->MoveSeekAssistanceDistract(sWorld->getConfig(CONFIG_CREATURE_FAMILY_ASSISTANCE_DELAY));
    }
}
