
#include "Common.h"
#include "Log.h"
#include "WorldPacket.h"
#include "WorldSession.h"
#include "World.h"
#include "Opcodes.h"
#include "ObjectMgr.h"
#include "Chat.h"
#include "Database/DatabaseEnv.h"
#include "ChannelMgr.h"
#include "Group.h"
#include "Guild.h"
#include "MapManager.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "SpellAuras.h"
#include "SpellAuraEffects.h"
#include "Language.h"
#include "Util.h"
#include "ScriptMgr.h"
#include "LogsDatabaseAccessor.h"
#include "GuildMgr.h"

#ifdef PLAYERBOT
#include "playerbot.h"
#endif

void WorldSession::HandleMessagechatOpcode( WorldPacket & recvData )
{
    uint32 type;
    uint32 lang;

    recvData >> type;
    recvData >> lang;

    if(type >= MAX_CHAT_MSG_TYPE)
    {
        TC_LOG_ERROR("network.opcode","CHAT: Wrong message type received: %u", type);
        return;
    }

    //TC_LOG_DEBUG("FIXME","CHAT: packet received. type %u, lang %u", type, lang );

    // prevent talking at unknown language (cheating)
    LanguageDesc const* langDesc = GetLanguageDescByID(lang);
    if(!langDesc)
    {
        SendNotification(LANG_UNKNOWN_LANGUAGE);
        return;
    }

    if(!IsReplaying() && langDesc->skill_id != 0 && !_player->HasSkill(langDesc->skill_id))
    {
        // also check SPELL_AURA_COMPREHEND_LANGUAGE (client offers option to speak in that language)
        auto const& langAuras = _player->GetAuraEffectsByType(SPELL_AURA_COMPREHEND_LANGUAGE);
        bool foundAura = false;
        for(auto langAura : langAuras)
        {
            if(langAura->GetMiscValue() == int32(lang))
            {
                foundAura = true;
                break;
            }
        }
        if(!foundAura)
        {
            SendNotification(LANG_NOT_LEARNED_LANGUAGE);
            return;
        }
    }

    if(lang == LANG_ADDON)
    {
        // Disabled addon channel?
        if(!sWorld->getConfig(CONFIG_ADDON_CHANNEL))
            return;
    }
    // LANG_ADDON should not be changed nor be affected by flood control
    else
    {
        // send in universal language if player in .gmon mode (ignore spell effects)
        if (_player->IsGameMaster())
            lang = LANG_UNIVERSAL;
        else
        {
            // send in universal language in two side iteration allowed mode
            if (sWorld->getConfig(CONFIG_ALLOW_TWO_SIDE_INTERACTION_CHAT))
                lang = LANG_UNIVERSAL;
            else
            {
                switch(type)
                {
                    case CHAT_MSG_PARTY:
                    case CHAT_MSG_RAID:
                    case CHAT_MSG_RAID_LEADER:
                    case CHAT_MSG_RAID_WARNING:
                        // allow two side chat at group channel if two side group allowed
                        if(sWorld->getConfig(CONFIG_ALLOW_TWO_SIDE_INTERACTION_GROUP))
                            lang = LANG_UNIVERSAL;
                        break;
                    case CHAT_MSG_GUILD:
                    case CHAT_MSG_OFFICER:
                        // allow two side chat at guild channel if two side guild allowed
                        if(sWorld->getConfig(CONFIG_ALLOW_TWO_SIDE_INTERACTION_GUILD))
                            lang = LANG_UNIVERSAL;
                        break;
                }
            }

            // but overwrite it by SPELL_AURA_MOD_LANGUAGE auras (only single case used)
            auto const& ModLangAuras = _player->GetAuraEffectsByType(SPELL_AURA_MOD_LANGUAGE);
            if(!ModLangAuras.empty())
                lang = ModLangAuras.front()->GetMiscValue();
        }

        //Flood control for these channels only
        if (type == CHAT_MSG_SAY
        || type == CHAT_MSG_YELL
        || type == CHAT_MSG_WHISPER
        || type == CHAT_MSG_EMOTE
        || type == CHAT_MSG_TEXT_EMOTE
        || type == CHAT_MSG_CHANNEL
        || type == CHAT_MSG_BG_SYSTEM_NEUTRAL
        || type == CHAT_MSG_BG_SYSTEM_ALLIANCE
        || type == CHAT_MSG_BG_SYSTEM_HORDE
        || type == CHAT_MSG_BATTLEGROUND
        || type == CHAT_MSG_BATTLEGROUND_LEADER)
        {
            GetPlayer()->UpdateSpeakTime();
            if ( !_player->CanSpeak() )
            {
                std::string timeStr = secsToTimeString(m_muteTime - time(nullptr));
                SendNotification(GetTrinityString(LANG_WAIT_BEFORE_SPEAKING),timeStr.c_str());
                return;
            }
        }
    }

   //GM Silence
   if (GetPlayer()->HasAuraEffect(1852,0) && type != CHAT_MSG_WHISPER)
   {
        std::string msg="";
        recvData >> msg;
        if (ChatHandler(this).ParseCommands(msg.c_str()) == 0)
        {
            SendNotification(GetTrinityString(LANG_GM_SILENCE), GetPlayer()->GetName().c_str());
            return;
        }
   }

   std::string msg = "";
   std::string to = "";

   if (type == CHAT_MSG_WHISPER || type == CHAT_MSG_CHANNEL)
       recvData >> to;

   recvData >> msg;

   // strip invisible characters for non-addon messages
   if (lang != LANG_ADDON && sWorld->getConfig(CONFIG_CHAT_FAKE_MESSAGE_PREVENTING))
       stripLineInvisibleChars(msg);

   //message can only be empty for those types
   if (type != CHAT_MSG_AFK && type != CHAT_MSG_DND && msg.empty())
       return;

   if(!msg.empty())
   {
       if (ChatHandler(this).ParseCommands(msg.c_str()) > 0)
           return;

       if (sWorld->IsPhishing(msg)) {
           sWorld->LogPhishing(GetPlayer()->GetGUID().GetCounter(), 0, msg);
           return;
        }
   }

    /* Is this to prevent linking fake items ?
    if (strncmp(msg.c_str(), "|cff", 4) == 0) {
        char* cEntry = ChatHandler(GetPlayer()).extractKeyFromLink(((char*)msg.c_str()), "Hitem");
        if (cEntry) {
            if (uint32 entry = atoi(cEntry)) {
                ItemTemplate const* proto = sObjectMgr->GetItemTemplate(entry);
                if (!proto)
                    break;
            }
            else
                break;
        }
    }
    */

   Player* toPlayer = nullptr;
   uint32 logChannelId = 0;

   switch(type)
   {
        case CHAT_MSG_SAY:
        case CHAT_MSG_EMOTE:
        case CHAT_MSG_YELL:
        {
            if (GetPlayer()->isSpectator())
            {
                //TODO translate
                SendNotification("Vous ne pouvez pas effectuer cette action lorsque vous êtes spectateur.");
                return;
            }

            if(type == CHAT_MSG_SAY)
                GetPlayer()->Say(msg, Language(lang));
            else if(type == CHAT_MSG_EMOTE)
                GetPlayer()->TextEmote(msg);
            else if(type == CHAT_MSG_YELL)
                GetPlayer()->Yell(msg, Language(lang));
        } break;

        case CHAT_MSG_WHISPER:
        {
            if(!normalizePlayerName(to))
            {
                WorldPacket data(SMSG_CHAT_PLAYER_NOT_FOUND, (to.size()+1));
                data<<to;
                SendPacket(&data);
                break;
            }

            toPlayer = ObjectAccessor::FindConnectedPlayerByName(to.c_str());
            uint32 playerSecurity = GetSecurity();
            uint32 targetSecurity = toPlayer ? toPlayer->GetSession()->GetSecurity() : 0;
            //stop here if target player not found
            //prevent sending whisps to gm not accepting whispers
            if(!toPlayer || ((playerSecurity == SEC_PLAYER) && (targetSecurity > SEC_PLAYER) && !toPlayer->IsAcceptWhispers()) )
            {
                WorldPacket data(SMSG_CHAT_PLAYER_NOT_FOUND, (to.size()+1));
                data<<to;
                SendPacket(&data);
                return;
            }

            // gm shoudln't send whisper addon message while invisible (this may help with players knowing a gamemaster is around in some case where both have addons)
            if (lang == LANG_ADDON && !GetPlayer()->IsVisible() && !toPlayer->IsGameMaster())
                break;

            // can't whisper others players before CONFIG_WHISPER_MINLEVEL but can still whisper GM's
            if (targetSecurity == SEC_PLAYER &&
                playerSecurity == SEC_PLAYER &&
                GetPlayer()->GetLevel() < sWorld->getConfig(CONFIG_WHISPER_MINLEVEL) &&
                lang != LANG_ADDON &&
                GetPlayer()->GetTotalPlayedTime() < 1 * DAY)
            {
                //"Vous devez atteindre le niveau %u ou avoir un temps de jeu total de 24h pour pouvoir chuchoter aux autres joueurs."
                ChatHandler(this).PSendSysMessage("You must reach level %u or have at least 24 hours of played to be able to whisper other players.", sWorld->getConfig(CONFIG_WHISPER_MINLEVEL));
                break;
            }

            if (!sWorld->getConfig(CONFIG_ALLOW_TWO_SIDE_INTERACTION_CHAT) && playerSecurity == SEC_PLAYER && targetSecurity == SEC_PLAYER )
            {
                uint32 sidea = GetPlayer()->GetTeam();
                uint32 sideb = toPlayer->GetTeam();
                if( sidea != sideb )
                {
                    WorldPacket data(SMSG_CHAT_PLAYER_NOT_FOUND, (to.size()+1));
                    data<<to;
                    SendPacket(&data);
                    return;
                }
            }

            if (GetPlayer()->HasAuraEffect(1852,0) && !toPlayer->IsGameMaster())
            {
                SendNotification(GetTrinityString(LANG_GM_SILENCE), GetPlayer()->GetName().c_str());
                return;
            }

            #ifdef PLAYERBOT
            // Playerbot mod: handle whispered command to bot
            if (toPlayer->GetPlayerbotAI() && lang != LANG_ADDON)
            {
                toPlayer->GetPlayerbotAI()->HandleCommand(type, msg, *GetPlayer());
                /* receiver->m_speakTime = 0;
                receiver->m_speakCount = 0; */
            }
            else
            #endif
                GetPlayer()->Whisper(msg, Language(lang),toPlayer);
        } break;

        case CHAT_MSG_PARTY:
#ifdef LICH_KING
        case CHAT_MSG_PARTY_LEADER:
#endif
        {
            // if player is in battleground, he cannot say to battleground members by /p
            Group *group = GetPlayer()->GetOriginalGroup();
            // so if player hasn't OriginalGroup and his player->GetGroup() is BG raid, then return
            if (!group && (!(group = GetPlayer()->GetGroup()) || group->isBGGroup()))
                return;

            #ifdef PLAYERBOT
            // Playerbot mod: broadcast message to bot members
            for(GroupReference* itr = group->GetFirstMember(); itr != nullptr; itr=itr->next())
            {
                Player* player = itr->GetSource();
                if (player && player->GetPlayerbotAI() && lang != LANG_ADDON)
                {
                    player->GetPlayerbotAI()->HandleCommand(type, msg, *GetPlayer());
                    /* GetPlayer()->m_speakTime = 0;
                    GetPlayer()->m_speakCount = 0; */
                }
            }
            #endif

            WorldPacket data;
            ChatHandler::BuildChatPacket(data, ChatMsg(type), Language(lang), GetPlayer(), nullptr, msg);
            group->BroadcastPacket(&data, false, group->GetMemberGroup(GetPlayer()->GetGUID()));

            logChannelId = group->GetLeaderGUID();
        }
        break;
        case CHAT_MSG_GUILD:
        {
            uint32 guildId = GetPlayer()->GetGuildId();
            if (!guildId)
                return;

            Guild* guild = sGuildMgr->GetGuildById(guildId);
            if (guild) {
                guild->BroadcastToGuild(this, false, msg, lang == LANG_ADDON ? LANG_ADDON : LANG_UNIVERSAL);
            }
            #ifdef PLAYERBOT
            // Playerbot mod: broadcast message to bot members
            PlayerbotMgr *mgr = GetPlayer()->GetPlayerbotMgr();
            if (mgr && lang != LANG_ADDON)
            {
                for (auto it = mgr->GetPlayerBotsBegin(); it != mgr->GetPlayerBotsEnd(); ++it)
                {
                    Player* const bot = it->second;
                    if (bot->GetGuildId() == GetPlayer()->GetGuildId())
                        bot->GetPlayerbotAI()->HandleCommand(type, msg, *GetPlayer());
                }
            }
            #endif

            logChannelId = guildId;

            break;
        }
        case CHAT_MSG_OFFICER:
        {
            if (GetPlayer()->GetGuildId())
                if (Guild *guild = sGuildMgr->GetGuildById(GetPlayer()->GetGuildId()))
                    guild->BroadcastToGuild(this, true, msg, lang == LANG_ADDON ? LANG_ADDON : LANG_UNIVERSAL);
            break;
        }
        case CHAT_MSG_RAID:
        case CHAT_MSG_RAID_LEADER:
        {
            // if player is in battleground group, he cannot talk to battleground members by /raid, even if this is a raid group.
            // Players can be simultaneously in a battleground group and original groups. Prefer original if both exists.
            Group* targetGroup = nullptr;
            Group* originalGroup = GetPlayer()->GetOriginalGroup();
            Group* currentGroup = GetPlayer()->GetGroup();

            if(originalGroup && originalGroup->isRaidGroup() && !originalGroup->isBGGroup())
                targetGroup = originalGroup;
            else if(currentGroup && currentGroup->isRaidGroup() && !currentGroup->isBGGroup())
                targetGroup = currentGroup;

            //no valid group found
            if(!targetGroup)
                return;

            #ifdef PLAYERBOT
            // Playerbot mod: broadcast message to bot members
            for(GroupReference* itr = targetGroup->GetFirstMember(); itr != nullptr; itr=itr->next())
            {
                Player* player = itr->GetSource();
                if (player && player->GetPlayerbotAI() && lang != LANG_ADDON)
                {
                    player->GetPlayerbotAI()->HandleCommand(type, msg, *GetPlayer());
                 /*   GetPlayer()->m_speakTime = 0;
                    GetPlayer()->m_speakCount = 0; */
                }
            }
            #endif

            WorldPacket data;
            ChatHandler::BuildChatPacket(data, ChatMsg(type), Language(lang), GetPlayer(), nullptr, msg);
            targetGroup->BroadcastPacket(&data, false);

            logChannelId = targetGroup->GetLeaderGUID();
        } break;
        case CHAT_MSG_RAID_WARNING:
        {
            Group *group = GetPlayer()->GetGroup();
            if(!group || !group->isRaidGroup() || !(group->IsLeader(GetPlayer()->GetGUID()) || group->IsAssistant(GetPlayer()->GetGUID())) || group->isBGGroup())
                return;

            WorldPacket data;
            // in battleground, raid warning is sent only to players in battleground - code is ok
            ChatHandler::BuildChatPacket(data, ChatMsg(type), Language(lang), GetPlayer(), nullptr, msg);
            group->BroadcastPacket(&data, false);

            logChannelId = group->GetLeaderGUID();
        } break;

        case CHAT_MSG_BATTLEGROUND_LEADER:
        {
            //battleground raid is always in Player->GetGroup(), never in GetOriginalGroup()
            Group* group = GetPlayer()->GetGroup();
            if (!group || !group->isBGGroup() || !group->IsLeader(GetPlayer()->GetGUID()))
                return;
        } //no break !
        case CHAT_MSG_BATTLEGROUND:
        {
            //battleground raid is always in Player->GetGroup(), never in GetOriginalGroup()
            Group* _group = GetPlayer()->GetGroup();
            if(!_group || !_group->isBGGroup())
                return;

            WorldPacket data;
            ChatHandler::BuildChatPacket(data, ChatMsg(type), Language(lang), GetPlayer(), nullptr, msg);
            _group->BroadcastPacket(&data, false);

            logChannelId = _group->GetLeaderGUID();
        } break;

        case CHAT_MSG_CHANNEL:
        {
            if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
            {
                if(Channel *chn = cMgr->GetChannel(to,_player))
                {
                    #ifdef PLAYERBOT
                    // Playerbot mod: broadcast message to bot members
                    if (_player->GetPlayerbotMgr() && lang != LANG_ADDON && chn->GetFlags() & 0x18)
                    {
                        _player->GetPlayerbotMgr()->HandleCommand(type, msg);
                    }
                    sRandomPlayerbotMgr.HandleCommand(type, msg, *_player);
                    #endif

                    chn->Say(_player->GetGUID(),msg.c_str(), Language(lang));
                }
            }
        } break;

        case CHAT_MSG_AFK:
        {
            if((msg.empty() || !_player->IsAFK()) && !_player->IsInCombat() )
            {
                if(!_player->IsAFK())
                {
                    if(msg.empty())
                        msg  = GetTrinityString(LANG_PLAYER_AFK_DEFAULT);
                    _player->afkMsg = msg;
                }
                _player->ToggleAFK();
                if(_player->IsAFK() && _player->IsDND())
                    _player->ToggleDND();
            }
        } break;

        case CHAT_MSG_DND:
        {
            if(msg.empty() || !_player->IsDND())
            {
                if(!_player->IsDND())
                {
                    if(msg.empty())
                        msg  = GetTrinityString(LANG_PLAYER_DND_DEFAULT);
                    _player->dndMsg = msg;
                }
                _player->ToggleDND();
                if(_player->IsDND() && _player->IsAFK())
                    _player->ToggleAFK();
            }
        } break;

        default:
            TC_LOG_ERROR("network.opcode","CHAT: unknown message type %u, lang: %u", type, lang);
            break;
    }

    LogsDatabaseAccessor::CharacterChat(ChatMsg(type), Language(lang), _player, toPlayer, logChannelId, to, msg);
}

void WorldSession::HandleEmoteOpcode( WorldPacket & recvData )
{
    if(!GetPlayer()->IsAlive())
        return;


    uint32 emote;
    recvData >> emote;
    GetPlayer()->HandleEmoteCommand(emote);
}

void WorldSession::HandleTextEmoteOpcode( WorldPacket & recvData )
{
    if(!_player->m_unitMovedByMe->IsAlive())
        return;

    GetPlayer()->UpdateSpeakTime();
    if (!GetPlayer()->CanSpeak())
    {
        std::string timeStr = secsToTimeString(m_muteTime - time(nullptr));
        SendNotification(GetTrinityString(LANG_WAIT_BEFORE_SPEAKING),timeStr.c_str());
        return;
    }


    uint32 text_emote, emoteNum;
    ObjectGuid guid;

    recvData >> text_emote;
    recvData >> emoteNum;
    recvData >> guid;

    Unit* _target = ObjectAccessor::GetUnit(*_player, guid);

    LocaleConstant loc_idx = _player->GetSession()->GetSessionDbcLocale();
    std::string const name(_target ? _target->GetNameForLocaleIdx(loc_idx) : "");
    uint32 namlen = name.size();

    EmotesTextEntry const *em = sEmotesTextStore.LookupEntry(text_emote);
    if (em)
    {
        uint32 emote_anim = em->textid;

        WorldPacket data;

        switch(emote_anim)
        {
            case EMOTE_STATE_SLEEP:
            case EMOTE_STATE_SIT:
            case EMOTE_STATE_KNEEL:
            case EMOTE_ONESHOT_NONE:
                break;
            default:
                _player->m_unitMovedByMe->HandleEmoteCommand(emote_anim);
                break;
        }

        if(_player->m_unitMovedByMe->ToPlayer()) //SMSG_TEXT_EMOTE is for player only
        {
            data.Initialize(SMSG_TEXT_EMOTE, (20+namlen));
            data << _player->m_unitMovedByMe->GetGUID();
            data << uint32(text_emote);
            data << uint32(emoteNum);
            data << uint32(namlen);
            if( namlen > 1 )
                data << name;
            else
                data << (uint8)0x00;

            _player->m_unitMovedByMe->SendMessageToSetInRange(&data,sWorld->getConfig(CONFIG_LISTEN_RANGE_TEXTEMOTE),true);
        }

        //Send scripted event call
        if(_target)
            if (Creature *pCreature = _target->ToCreature()) {
                pCreature->AI()->ReceiveEmote(GetPlayer(), text_emote);
            }
    }
}

void WorldSession::HandleChatIgnoredOpcode(WorldPacket& recvData )
{
    ObjectGuid iguid;
    uint8 reason;
    //TC_LOG_DEBUG("network.opcode","WORLD: Received CMSG_CHAT_IGNORED");

    recvData >> iguid;
    recvData >> reason; //not 100% sure but this is from 4.0x

    Player *player = ObjectAccessor::FindPlayer(iguid);
    if(!player || !player->GetSession())
        return;

    WorldPacket data;
    ChatHandler::BuildChatPacket(data, CHAT_MSG_IGNORED, LANG_UNIVERSAL, nullptr,  GetPlayer(), GetPlayer()->GetName().c_str());
    player->SendDirectMessage(&data);
}

void WorldSession::HandleChannelDeclineInvite(WorldPacket &recvPacket)
{
    // TODO
}
