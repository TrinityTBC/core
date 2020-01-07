//add here most rarely modified headers to speed up debug build compilation

#include "DatabaseEnv.h"
#include "DBCStores.h"
#include "Errors.h"
#include "Util.h"
#include "Log.h"
#include "ObjectAccessor.h"
#include "ObjectMgr.h"
#include "PacketUtilities.h"
#include "Creature.h"
#include "GameObject.h"
#include "Player.h"
#include "World.h"
#include "WorldPacket.h"
#include "WorldSession.h"

#ifdef PLAYERBOT
	#include "playerbot.h"
	#include "GenericActions.h"
	#include "NonCombatStrategy.h"
	#include "CombatStrategy.h"
	#include "RangedCombatStrategy.h"
	#include "GenericTriggers.h"
	#include "AiObjectContext.h"
#endif
