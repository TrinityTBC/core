
#include "Creature.h"
#include "MapManager.h"
#include "ConfusedMovementGenerator.h"
#include "PathGenerator.h"
#include "Management/VMapFactory.h"
#include "MoveSplineInit.h"
#include "MoveSpline.h"
#include "Player.h"
#include "MovementDefines.h"


template<class T>
ConfusedMovementGenerator<T>::ConfusedMovementGenerator() : _timer(0), _x(0.f), _y(0.f), _z(0.f)
{
    this->Mode = MOTION_MODE_DEFAULT;
    this->Priority = MOTION_PRIORITY_HIGHEST;
    this->Flags = MOVEMENTGENERATOR_FLAG_INITIALIZATION_PENDING;
    this->BaseUnitState = UNIT_STATE_CONFUSED;
}

template<class T>
MovementGeneratorType ConfusedMovementGenerator<T>::GetMovementGeneratorType() const
{
    return CONFUSED_MOTION_TYPE;
}

template<class T>
void ConfusedMovementGenerator<T>::DoInitialize(T* owner)
{
    MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_INITIALIZATION_PENDING | MOVEMENTGENERATOR_FLAG_DEACTIVATED | MOVEMENTGENERATOR_FLAG_TRANSITORY);
    MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_INITIALIZED);

    if (!owner || !owner->IsAlive())
        return;

    // TODO: UNIT_FIELD_FLAGS should not be handled by generators
    owner->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_CONFUSED);
    owner->StopMoving();

    _timer.Reset(0);
    owner->GetPosition(_x, _y, _z);
    _path = nullptr;
}

template<class T>
void ConfusedMovementGenerator<T>::DoReset(T* owner)
{
    MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_TRANSITORY | MOVEMENTGENERATOR_FLAG_DEACTIVATED);

    DoInitialize(owner);
}

template<class T>
bool ConfusedMovementGenerator<T>::DoUpdate(T* owner, uint32 diff)
{
    if (!owner || !owner->IsAlive())
        return false;

    if (owner->HasUnitState(UNIT_STATE_NOT_MOVE) || owner->IsMovementPreventedByCasting() || owner->HasUnitMovementFlag(MOVEMENTFLAG_JUMPING_OR_FALLING)) //sun: added falling
    {
        MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_INTERRUPTED);
        owner->StopMoving();
        _path = nullptr;
        return true;
    }
    else
        MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_INTERRUPTED);

    // waiting for next move
    _timer.Update(diff);
    if ((MovementGenerator::HasFlag(MOVEMENTGENERATOR_FLAG_SPEED_UPDATE_PENDING) && !owner->movespline->Finalized()) || (_timer.Passed() && owner->movespline->Finalized()))
    {
        // start moving
        MovementGenerator::RemoveFlag(MOVEMENTGENERATOR_FLAG_TRANSITORY);

        float dest = 4.0f * (float)rand_norm() - 2.0f;

        Position destination(_x, _y, _z);
        owner->MovePositionToFirstWalkableCollision(destination, dest, 0.0f);

        _path = std::make_unique<PathGenerator>(owner); //sun: new generator at each update, to update options and position
        _path->SetPathLengthLimit(10.0f);
        _path->ExcludeSteepSlopes();

        Transport* ownerTransport = owner->GetTransport();
        _path->SetTransport(ownerTransport);

        bool result = _path->CalculatePath(destination.m_positionX, destination.m_positionY, destination.m_positionZ);
        if (!result || (_path->GetPathType() & PATHFIND_NOPATH))
        {
            _timer.Reset(100);
            return true;
        }

        owner->AddUnitState(UNIT_STATE_CONFUSED_MOVE);

        Movement::MoveSplineInit init(owner);
        init.MovebyPath(_path->GetPath(), 0, ownerTransport);
        init.SetWalk(true);
        int32 traveltime = init.Launch();
        _timer.Reset(traveltime + urand(800, 1500));
    }

    return true;
}

template<class T>
void ConfusedMovementGenerator<T>::DoDeactivate(T* owner)
{
    MovementGenerator::AddFlag(MOVEMENTGENERATOR_FLAG_DEACTIVATED);
    owner->ClearUnitState(UNIT_STATE_CONFUSED_MOVE);
}

template<class T>
void ConfusedMovementGenerator<T>::DoFinalize(T*, bool, bool) { }

template<>
void ConfusedMovementGenerator<Player>::DoFinalize(Player* owner, bool active, bool/* movementInform*/)
{
    AddFlag(MOVEMENTGENERATOR_FLAG_FINALIZED);

     if (active)
    {
        owner->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_CONFUSED);
        owner->StopMoving();
    }
}

template<>
void ConfusedMovementGenerator<Creature>::DoFinalize(Creature* owner, bool active, bool/* movementInform*/)
{
    AddFlag(MOVEMENTGENERATOR_FLAG_FINALIZED);

    if (active)
    {
        owner->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_CONFUSED);
        owner->ClearUnitState(UNIT_STATE_CONFUSED | UNIT_STATE_CONFUSED_MOVE);
        if (owner->GetVictim())
            owner->SetTarget(owner->EnsureVictim()->GetGUID());
    }
}

template ConfusedMovementGenerator<Player>::ConfusedMovementGenerator();
template ConfusedMovementGenerator<Creature>::ConfusedMovementGenerator();
template MovementGeneratorType ConfusedMovementGenerator<Player>::GetMovementGeneratorType() const;
template MovementGeneratorType ConfusedMovementGenerator<Creature>::GetMovementGeneratorType() const;
template void ConfusedMovementGenerator<Player>::DoInitialize(Player*);
template void ConfusedMovementGenerator<Creature>::DoInitialize(Creature*);
template void ConfusedMovementGenerator<Player>::DoReset(Player*);
template void ConfusedMovementGenerator<Creature>::DoReset(Creature*);
template bool ConfusedMovementGenerator<Player>::DoUpdate(Player*, uint32);
template bool ConfusedMovementGenerator<Creature>::DoUpdate(Creature*, uint32);
template void ConfusedMovementGenerator<Player>::DoDeactivate(Player*);
template void ConfusedMovementGenerator<Creature>::DoDeactivate(Creature*);
