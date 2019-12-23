
#include "Creature.h"
#include "MovementDefines.h"
#include "MovementGenerator.h"
#include "IdleMovementGenerator.h"
#include "RandomMovementGenerator.h"
#include "WaypointMovementGenerator.h"

MovementGenerator::~MovementGenerator() { }

std::string MovementGenerator::GetDebugInfo() const
{
    std::stringstream sstr;
    sstr << std::boolalpha
        << "Mode: " << std::to_string(Mode)
        << " Priority: " << std::to_string(Priority)
        << " Flags: " << Flags
        << " BaseUniteState: " << BaseUnitState;
    return sstr.str();
}

IdleMovementFactory::IdleMovementFactory() : MovementGeneratorCreator(IDLE_MOTION_TYPE) { }

MovementGenerator* IdleMovementFactory::Create(Unit* /*object*/) const
{
    static IdleMovementGenerator instance;
    return &instance;
}

RandomMovementFactory::RandomMovementFactory() : MovementGeneratorCreator(RANDOM_MOTION_TYPE) { }

MovementGenerator* RandomMovementFactory::Create(Unit* /*object*/) const
{
    return new RandomMovementGenerator<Creature>();
}

WaypointMovementFactory::WaypointMovementFactory() : MovementGeneratorCreator(WAYPOINT_MOTION_TYPE) { }

MovementGenerator* WaypointMovementFactory::Create(Unit* /*object*/) const
{
    return new WaypointMovementGenerator<Creature>();
}
