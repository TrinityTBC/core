#include "ObjectMgr.h"                                      // for normalizePlayerName
#include "Log.h"
#include "ChannelMgr.h"
#include "Channel.h"
#include <utf8.h>

void WorldSession::HandleJoinChannel(WorldPacket& recvPacket)
{
    uint32 channel_id;
    uint8 unknown1, hasVoice;
    std::string channelName, pass;

    recvPacket >> channel_id >> unknown1 >> hasVoice;
    recvPacket >> channelName;

    if (channelName.empty() || iswdigit(channelName[0]))
    {
        WorldPacket data(SMSG_CHANNEL_NOTIFY, 1 + channelName.size());
        data << uint8(CHAT_INVALID_NAME_NOTICE) << channelName;
        SendPacket(&data);
        return;
    }

    if (!utf8::is_valid(channelName.begin(), channelName.end()))
    {
        TC_LOG_ERROR("network", "Player %s tried to create a channel with an invalid UTF8 sequence - blocked", GetPlayer()->GetGUID().ToString().c_str());
        return;
    }

    if (!ValidateHyperlinksAndMaybeKick(channelName))
        return;
        
    if (strcmp(channelName.c_str(), "gmworlda") == 0 && !_player->IsGameMaster())
        return;
        
    if (strcmp(channelName.c_str(), "gmworldh") == 0 && !_player->IsGameMaster())
        return;

    recvPacket >> pass;
    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetJoinChannel(channelName, channel_id))
            chn->Join(_player->GetGUID(), pass.c_str());
}

void WorldSession::HandleLeaveChannel(WorldPacket& recvPacket)
{
    uint32 zoneChannelID;
    std::string channelName;
    recvPacket >> zoneChannelID;
    recvPacket >> channelName;

    if(channelName.empty())
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
    {
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->Leave(_player->GetGUID(), true);
        cMgr->LeftChannel(channelName);
    }
}

void WorldSession::HandleChannelList(WorldPacket& recvPacket)
{
    std::string channelName;
    recvPacket >> channelName;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->List(_player);
}

void WorldSession::HandleChannelPassword(WorldPacket& recvPacket)
{
    std::string channelName, pass;
    recvPacket >> channelName;
    recvPacket >> pass;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->Password(_player->GetGUID(), pass.c_str());
}

void WorldSession::HandleChannelSetOwner(WorldPacket& recvPacket)
{
    std::string channelName, newp;
    recvPacket >> channelName;
    recvPacket >> newp;

    if(!normalizePlayerName(newp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->SetOwner(_player->GetGUID(), newp.c_str());
}

void WorldSession::HandleChannelOwner(WorldPacket& recvPacket)
{
    std::string channelName;
    recvPacket >> channelName;
    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->SendWhoOwner(_player->GetGUID());
}

void WorldSession::HandleChannelModerator(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;

    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->SetModerator(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelUnmoderator(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;

    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->UnsetModerator(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelMute(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;

    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->SetMute(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelUnmute(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;

    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->UnsetMute(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelInvite(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;

    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->Invite(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelKick(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;
    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->Kick(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelBan(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;

    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->Ban(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelUnban(WorldPacket& recvPacket)
{
    std::string channelName, otp;
    recvPacket >> channelName;
    recvPacket >> otp;

    if(!normalizePlayerName(otp))
        return;

    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->UnBan(_player->GetGUID(), otp.c_str());
}

void WorldSession::HandleChannelAnnouncements(WorldPacket& recvPacket)
{
    std::string channelName;
    recvPacket >> channelName;
    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->Announce(_player->GetGUID());
}

void WorldSession::HandleChannelModerate(WorldPacket& recvPacket)
{
    std::string channelName;
    recvPacket >> channelName;
    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->Moderate(_player->GetGUID());
}

void WorldSession::HandleChannelDisplayListQuery(WorldPacket &recvPacket)
{
    std::string channelName;
    recvPacket >> channelName;
    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->List(_player);
}

void WorldSession::HandleGetChannelMemberCount(WorldPacket &recvPacket)
{
    std::string channelName;
    recvPacket >> channelName;
    if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
    {
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
        {
            WorldPacket data(SMSG_CHANNEL_MEMBER_COUNT, chn->GetName().size()+1+1+4);
            data << chn->GetName();
            data << uint8(chn->GetFlags());
            data << uint32(chn->GetNumPlayers());
            SendPacket(&data);
        }
    }
}

void WorldSession::HandleSetChannelWatch(WorldPacket &recvPacket)
{
    std::string channelName;
    recvPacket >> channelName;
    /*if(ChannelMgr* cMgr = channelMgr(_player->GetTeam()))
        if(Channel *chn = cMgr->GetChannel(channelName, _player))
            chn->JoinNotify(_player->GetGUID());*/
}