/*
 * Copyright (C) 2008-2019 TrinityCore <https://www.trinitycore.org/>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef GameObjectData_h__
#define GameObjectData_h__

#include "Common.h"
#include "SharedDefines.h"
#include "SpawnData.h"
#include "WorldPacket.h"
#include <string>
#include <vector>

// from `gameobject_template`
struct TC_GAME_API GameObjectTemplate
{
    uint32  entry;
    uint32  type;
    uint32  displayId;
    std::string name;
    std::string IconName;
    std::string castBarCaption;
    std::string unk1;
    uint32  faction;
    uint32  flags;
    float   size;
    union                                                   // different GO types have different data field
    {
        //0 GAMEOBJECT_TYPE_DOOR
        struct
        {
            uint32 startOpen;                               //0 used client side to determine GO_ACTIVATED means open/closed
            uint32 lockId;                                  //1 -> Lock.dbc
            uint32 autoCloseTime;                           //2 secs till autoclose = autoCloseTime / 0x10000
            uint32 noDamageImmune;                          //3 break opening whenever you recieve damage?
            uint32 openTextID;                              //4 can be used to replace castBarCaption?
            uint32 closeTextID;                             //5
        } door;
        //1 GAMEOBJECT_TYPE_BUTTON
        struct
        {
            uint32 startOpen;                               //0
            uint32 lockId;                                  //1 -> Lock.dbc
            uint32 autoCloseTime;                           //2 secs till autoclose = autoCloseTime / 0x10000
            uint32 linkedTrap;                              //3
            uint32 noDamageImmune;                          //4 isBattlegroundObject
            uint32 large;                                   //5
            uint32 openTextID;                              //6 can be used to replace castBarCaption?
            uint32 closeTextID;                             //7
            uint32 losOK;                                   //8
        } button;
        //2 GAMEOBJECT_TYPE_QUESTGIVER
        struct
        {
            uint32 lockId;                                  //0 -> Lock.dbc
            uint32 questList;                               //1
            uint32 pageMaterial;                            //2
            uint32 gossipID;                                //3
            uint32 customAnim;                              //4
            uint32 noDamageImmune;                          //5
            uint32 openTextID;                              //6 can be used to replace castBarCaption?
            uint32 losOK;                                   //7
            uint32 allowMounted;                            //8
            uint32 large;                                   //9
        } questgiver;
        //3 GAMEOBJECT_TYPE_CHEST
        struct
        {
            uint32 lockId;                                  //0 -> Lock.dbc
            uint32 lootId;                                  //1
            uint32 chestRestockTime;                        //2
            uint32 consumable;                              //3
            uint32 minSuccessOpens;                         //4
            uint32 maxSuccessOpens;                         //5
            uint32 eventId;                                 //6 lootedEvent
            uint32 linkedTrapId;                            //7
            uint32 questId;                                 //8 store quest required for GO activation for player
            uint32 level;                                   //9
            uint32 losOK;                                   //10
            uint32 leaveLoot;                               //11
            uint32 notInCombat;                             //12
            uint32 logLoot;                                 //13
            uint32 openTextID;                              //14 can be used to replace castBarCaption?
            uint32 groupLootRules;                          //15
        } chest;
        //5 GAMEOBJECT_TYPE_GENERIC
        struct
        {
            uint32 floatingTooltip;                         //0
            uint32 highlight;                               //1
            uint32 serverOnly;                              //2
            uint32 large;                                   //3
            uint32 floatOnWater;                            //4
            int32 questID;                                  //5
        } _generic;
        //6 GAMEOBJECT_TYPE_TRAP
        struct
        {
            uint32 lockId;                                  //0 -> Lock.dbc
            uint32 level;                                   //1
            uint32 diameter;                                //2 diameter for trap activation
            uint32 spellId;                                 //3
            uint32 type;                                    //4 0 trap with no despawn after cast. 1 trap despawns after cast. 2 bomb casts on spawn.
            uint32 cooldown;                                //5 time in secs
            uint32 autoCloseTime;                           //6
            uint32 startDelay;                              //7
            uint32 serverOnly;                              //8
            uint32 stealthed;                               //9
            uint32 large;                                   //10
            uint32 invisible;                               //11
            uint32 openTextID;                              //12 can be used to replace castBarCaption?
            uint32 closeTextID;                             //13
        } trap;
        //7 GAMEOBJECT_TYPE_CHAIR
        struct
        {
            uint32 slots;                                   //0
            uint32 height;                                  //1
            uint32 onlyCreatorUse;                          //2
        } chair;
        //8 GAMEOBJECT_TYPE_SPELL_FOCUS
        struct
        {
            uint32 focusId;                                 //0
            uint32 dist;                                    //1
            uint32 linkedTrapId;                            //2
            uint32 serverOnly;                              //3
            uint32 questID;                                 //4
            uint32 large;                                   //5
        } spellFocus;
        //9 GAMEOBJECT_TYPE_TEXT
        struct
        {
            uint32 pageID;                                  //0
            uint32 language;                                //1
            uint32 pageMaterial;                            //2
            uint32 allowMounted;                            //3
        } text;
        //10 GAMEOBJECT_TYPE_GOOBER
        struct
        {
            uint32 lockId;                                  //0 -> Lock.dbc
            int32 questId;                                  //1
            uint32 eventId;                                 //2
            uint32 autoCloseTime;                           //3
            uint32 customAnim;                              //4
            uint32 consumable;                              //5
            uint32 cooldown;                                //6
            uint32 pageId;                                  //7
            uint32 language;                                //8
            uint32 pageMaterial;                            //9
            uint32 spellId;                                 //10
            uint32 noDamageImmune;                          //11
            uint32 linkedTrapId;                            //12
            uint32 large;                                   //13
            uint32 openTextID;                              //14 can be used to replace castBarCaption?
            uint32 closeTextID;                             //15
            uint32 losOK;                                   //16 isBattlegroundObject
            uint32 allowMounted;                            //17
            uint32 floatingTooltip;                         //18 NYI
            uint32 gossipID;                                //19
        } goober;
        //11 GAMEOBJECT_TYPE_TRANSPORT
        struct
        {
            uint32 pauseAtTime;                             //0
            uint32 startOpen;                               //1
            uint32 autoCloseTime;                           //2 secs till autoclose = autoCloseTime / 0x10000
        } transport;
        //12 GAMEOBJECT_TYPE_AREADAMAGE
        struct
        {
            uint32 lockId;                                  //0
            uint32 radius;                                  //1
            uint32 damageMin;                               //2
            uint32 damageMax;                               //3
            uint32 damageSchool;                            //4
            uint32 autoCloseTime;                           //5 secs till autoclose = autoCloseTime / 0x10000
            uint32 openTextID;                              //6
            uint32 closeTextID;                             //7
        } areadamage;
        //13 GAMEOBJECT_TYPE_CAMERA
        struct
        {
            uint32 lockId;                                  //0 -> Lock.dbc
            uint32 cinematicId;                             //1
            uint32 eventID;                                 //2
            uint32 openTextID;                              //3 can be used to replace castBarCaption?
        } camera;
        //15 GAMEOBJECT_TYPE_MO_TRANSPORT
        struct
        {
            uint32 taxiPathId;                              //0
            uint32 moveSpeed;                               //1
            uint32 accelRate;                               //2
            uint32 startEventID;                            //3
            uint32 stopEventID;                             //4
            uint32 transportPhysics;                        //5
            uint32 mapID;                                   //6
            uint32 worldState1;                             //7
            uint32 canBeStopped;                            //8 used on LK only
        } moTransport;
        //17 GAMEOBJECT_TYPE_FISHINGNODE
        struct
        {
            uint32 _data0;                                  //0
            uint32 lootId;                                  //1
        } fishnode;
        //18 GAMEOBJECT_TYPE_SUMMONING_RITUAL
        struct
        {
            uint32 reqParticipants;                         //0
            uint32 spellId;                                 //1
            uint32 animSpell;                               //2
            uint32 ritualPersistent;                        //3
            uint32 casterTargetSpell;                       //4
            uint32 casterTargetSpellTargets;                //5
            uint32 castersGrouped;                          //6
            uint32 ritualNoTargetCheck;                     //7
        } summoningRitual;
        //20 GAMEOBJECT_TYPE_AUCTIONHOUSE
        struct
        {
            uint32 actionHouseID;                           //0
        } auctionhouse;
        //21 GAMEOBJECT_TYPE_GUARDPOST
        struct
        {
            uint32 creatureID;                              //0
            uint32 charges;                                 //1
        } guardpost;
        //22 GAMEOBJECT_TYPE_SPELLCASTER
        struct
        {
            uint32 spellId;                                 //0
            uint32 charges;                                 //1
            uint32 partyOnly;                               //2
            uint32 allowMounted;                            //3 Is usable while on mount/vehicle. (0/1)
            uint32 large;                                   //4 NYI
            uint32 conditionID1;                            //5 NYI
        } spellcaster;
        //23 GAMEOBJECT_TYPE_MEETINGSTONE
        struct
        {
            uint32 minLevel;                                //0
            uint32 MaxLevel;                                //1
            uint32 areaID;                                  //2
        } meetingstone;
        //24 GAMEOBJECT_TYPE_FLAGSTAND
        struct
        {
            uint32 lockId;                                  //0
            uint32 pickupSpell;                             //1
            uint32 radius;                                  //2
            uint32 returnAura;                              //3
            uint32 returnSpell;                             //4
            uint32 noDamageImmune;                          //5
            uint32 openTextID;                              //6
            uint32 losOK;                                   //7
            uint32 conditionID1;                            //8 NYI
        } flagstand;
        //25 GAMEOBJECT_TYPE_FISHINGHOLE                    // not implemented yet
        struct
        {
            uint32 radius;                                  //0 how close bobber must land for sending loot
            uint32 lootId;                                  //1
            uint32 minSuccessOpens;                         //2
            uint32 maxSuccessOpens;                         //3
            uint32 lockId;                                  //4 -> Lock.dbc; possibly 1628 for all?
        } fishinghole;
        //26 GAMEOBJECT_TYPE_FLAGDROP
        struct
        {
            uint32 lockId;                                  //0
            uint32 eventID;                                 //1
            uint32 pickupSpell;                             //2
            uint32 noDamageImmune;                          //3
            uint32 openTextID;                              //4
        } flagdrop;
        //27 GAMEOBJECT_TYPE_MINI_GAME
        struct
        {
            uint32 gameType;                                //0
        } miniGame;
        //29 GAMEOBJECT_TYPE_CAPTURE_POINT
        struct
        {
            uint32 radius;                                  //0
            uint32 spell;                                   //1
            uint32 worldState1;                             //2
            uint32 worldstate2;                             //3
            uint32 winEventID1;                             //4
            uint32 winEventID2;                             //5
            uint32 contestedEventID1;                       //6
            uint32 contestedEventID2;                       //7
            uint32 progressEventID1;                        //8
            uint32 progressEventID2;                        //9
            uint32 neutralEventID1;                         //10
            uint32 neutralEventID2;                         //11
            uint32 neutralPercent;                          //12
            uint32 worldstate3;                             //13
            uint32 minSuperiority;                          //14
            uint32 maxSuperiority;                          //15
            uint32 minTime;                                 //16
            uint32 maxTime;                                 //17
            uint32 large;                                   //18
            uint32 highlight;                               //19
        } capturePoint;
        //30 GAMEOBJECT_TYPE_AURA_GENERATOR
        struct
        {
            uint32 startOpen;                               //0
            uint32 radius;                                  //1
            uint32 auraID1;                                 //2
            uint32 conditionID1;                            //3
            uint32 auraID2;                                 //4
            uint32 conditionID2;                            //5
            uint32 serverOnly;                              //6
        } auraGenerator;
        //31 GAMEOBJECT_TYPE_DUNGEON_DIFFICULTY
        struct
        {
            uint32 mapID;                                   //0
            uint32 difficulty;                              //1
        } dungeonDifficulty;
        //32 GAMEOBJECT_TYPE_BARBER_CHAIR
        struct
        {
            uint32 chairheight;                             //0
            uint32 heightOffset;                            //1
        } barberChair;
        //33 GAMEOBJECT_TYPE_DESTRUCTIBLE_BUILDING
        struct
        {
            uint32 dmgPctState1;                            //0
            uint32 dmgPctState2;                            //1
            uint32 state1Name;                              //2
            uint32 state2Name;                              //3
        } destructibleBuilding;
        //34 GAMEOBJECT_TYPE_GUILDBANK
        struct
        {
            uint32 conditionID1;                            //0
        } guildbank;
#ifdef LICH_KING
        //35 GAMEOBJECT_TYPE_TRAPDOOR
        struct
        {
            uint32 whenToPause;                             // 0
            uint32 startOpen;                               // 1
            uint32 autoClose;                               // 2
        } trapDoor;
#endif

        // not use for specific field access (only for output with loop by all filed), also this determinate max union size
        struct                                              // GAMEOBJECT_TYPE_SPELLCASTER
        {
            uint32 data[MAX_GAMEOBJECT_DATA];
        } raw;
    };

    //helpers 
    uint32 GetAutoCloseTime() const;
    bool IsDespawnAtAction() const;
    bool IsUsableMounted() const;
    bool IsIgnoringLOSChecks() const;
    bool IsLargeGameObject() const;
    uint32 GetLootId() const;
    // despawn at uses amount
    uint32 GetCharges() const;                               
    uint32 GetGossipMenuId() const;
    // Cooldown preventing goober and traps to cast spell
    uint32 GetCooldown() const;
    // despawn at targeting of cast?
    bool GetDespawnPossibility() const;
    uint32 GetLinkedGameObjectEntry() const;
    uint32 GetLockId() const;
    uint32 GetEventScriptId() const;

    void InitializeQueryData();
    WorldPacket BuildQueryData(LocaleConstant loc) const;

    std::string AIName;
    uint32 ScriptId;
    WorldPacket QueryData[TOTAL_LOCALES];
};

struct GameObjectLocale
{
    std::vector<std::string> Name;
    std::vector<std::string> CastBarCaption;
};

struct TC_GAME_API QuaternionData
{
    float x, y, z, w;

    QuaternionData() : x(0.0f), y(0.0f), z(0.0f), w(1.0f) { }
    QuaternionData(float X, float Y, float Z, float W) : x(X), y(Y), z(Z), w(W) { }

    bool isUnit() const;
    void toEulerAnglesZYX(float& Z, float& Y, float& X) const;
    static QuaternionData fromEulerAnglesZYX(float Z, float Y, float X);
};

// from `gameobject`
struct GameObjectData : public SpawnData
{
    GameObjectData() : SpawnData(SPAWN_TYPE_GAMEOBJECT) { }
    uint32 id; // entry in gameobject_template table
    QuaternionData rotation;
    uint32 animprogress;
    GOState goState = GO_STATE_ACTIVE;
    uint8 artKit = 0;
};

#endif