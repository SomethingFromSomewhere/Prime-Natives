#include <prime_natives>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name		= 	"[Prime Natives] Admin Access",
	author		= 	"Someone",
	description = 	"Provides access for users without Prime who has admin access.",
	version		= 	"1.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

public Action PN_OnPlayerStatusChange(int iClient, PRIME_STATUS &iNewStatus, STATUS_CHANGE_REASON iReason)
{
	if(CheckCommandAccess(iClient, "sm_prime_natives_admin_access", ADMFLAG_ROOT, true))
	{
		if(iReason == WHITE_LIST_REMOVE)	return Plugin_Stop;
		else if(iNewStatus != PRIME && iReason == PLAYER_LOAD)
		{
			iNewStatus = WHITE_LIST;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}