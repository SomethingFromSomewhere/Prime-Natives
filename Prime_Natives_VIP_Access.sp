#include <prime_natives>
#include <vip_core>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name		= "[Prime Natives] VIP Access",
	author		= "Someone",
	version		= "1.0",
	description = "Provides access for users without Prime who has VIP status.",
	url			= "https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

char g_sVIPGroup[32];

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_prime_natives_vip_access_group", "", "Leave empty for grant access for all VIP groups.")).AddChangeHook(ChangeCvar_APIKey);
	CVAR.GetString(g_sVIPGroup, sizeof(g_sVIPGroup));
	
	AutoExecConfig(true, "vip_access", "sourcemod/prime_natives");
}

public void ChangeCvar_APIKey(ConVar CVAR, char[] oldValue, char[] newValue)
{	
	CVAR.GetString(g_sVIPGroup, sizeof(g_sVIPGroup));
}

public void VIP_OnVIPClientRemoved(int iClient, const char[] szReason, int iAdmin)
{
	if(PN_GetPlayerStatus(iClient) == WHITE_LIST)
	{
		PN_ForcePlayerCheck(iClient, WHITE_LIST_REMOVE);
	}
}

public Action PN_OnPlayerStatusChange(int iClient, PRIME_STATUS &iNewStatus, STATUS_CHANGE_REASON iReason)
{
	if(iNewStatus == NO_PRIME)
	{
		if(g_sVIPGroup[0])
		{
			char sBuffer[32];
			VIP_GetClientVIPGroup(iClient, sBuffer, sizeof(sBuffer));
			if(!strcmp(sBuffer, g_sVIPGroup))
			{
				iNewStatus = WHITE_LIST;
				return Plugin_Changed;
			}
		}
		else if(VIP_IsClientVIP(iClient))
		{
			iNewStatus = WHITE_LIST;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}