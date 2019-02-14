#include <prime_natives>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name		= 	"[Prime Natives] Tag",
	author		= 	"Someone",
	version		= 	"1.0.0",
	description =	"Force clan tag for non Prime users.",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

char g_sTag[16];

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_prime_natives_clan_tag",	"[No Prime]", "TAG for users without Prime status.")).AddChangeHook(ChangeCvar_Tag);
	CVAR.GetString(g_sTag, sizeof(g_sTag));
	
	AutoExecConfig(true, "tag", "sourcemod/prime_natives");
}

public void ChangeCvar_Tag(ConVar CVAR, const char[] oldValue, const char[] newValue)
{
	CVAR.GetString(g_sTag, sizeof(g_sTag));
}

public void PN_OnPlayerStatusChangePost(int iClient, PRIME_STATUS iNewStatus, STATUS_CHANGE_REASON iReason)
{
	if(iNewStatus == NO_PRIME && IsClientInGame(iClient))
	{
		CS_SetClientClanTag(iClient, g_sTag);
	}
}

public void OnClientSettingsChanged(int iClient)
{
	if(!IsFakeClient(iClient) && PN_GetPlayerStatus(iClient) == NO_PRIME) 
	{
		static char sBuffer[16];
		CS_GetClientClanTag(iClient, sBuffer, sizeof(sBuffer));
		if(strcmp(sBuffer, g_sTag) != 0)
		{
			CS_SetClientClanTag(iClient, g_sTag);
		}
    }
}