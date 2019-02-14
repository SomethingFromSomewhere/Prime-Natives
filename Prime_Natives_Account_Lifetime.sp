#include <prime_natives>
#include <SteamWorks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name		= 	"[Prime Natives] Account Lifetime",
	author		= 	"Someone",
	version		= 	"1.0",
	description =	"Checks players account registration date.",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa",
};

int g_iDays;
char g_sAPIKey[34];
bool g_bAccess[MAXPLAYERS+1];

public void OnPluginStart()
{
	ConVar CVAR;
	
	(CVAR = CreateConVar("sm_prime_natives_account_lifetime_minimum_days", "31", "Minimum account lifetime by days.", _, true, 1.0)).AddChangeHook(ChangeCvar_MinimumTime);
	g_iDays = 86400*CVAR.IntValue;
	
	(CVAR = CreateConVar("sm_prime_natives_account_lifetime_api_key", "", "Steam Web API Key.")).AddChangeHook(ChangeCvar_APIKey);
	CVAR.GetString(g_sAPIKey, sizeof(g_sAPIKey));
	
	AutoExecConfig(true, "account_lifetime", "sourcemod/prime_natives");
}

public void ChangeCvar_MinimumTime(ConVar CVAR, char[] oldValue, char[] newValue)
{	
	g_iDays = 86400*CVAR.IntValue;
}

public void ChangeCvar_APIKey(ConVar CVAR, char[] oldValue, char[] newValue)
{	
	CVAR.GetString(g_sAPIKey, sizeof(g_sAPIKey));
}

public void OnConfigsExecuted()
{
	if(!g_sAPIKey[0])
	{
		LogError("[PN][Account Time] Set yours Steam Web API key! Example: sm_prime_natives_api_key `API Key`.");
	}
}

public Action PN_OnPlayerStatusChange(int iClient, PRIME_STATUS &iNewStatus, STATUS_CHANGE_REASON iReason)
{
	if(iReason == PLAYER_LOAD && iNewStatus != PRIME)
	{
		iNewStatus = VERIFICATION;
		
		Handle hRequest = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/");
		
		SteamWorks_SetHTTPRequestNetworkActivityTimeout(hRequest, 10);
		
		char sSteamID64[20];
		GetClientAuthId(iClient, AuthId_SteamID64, sSteamID64, sizeof(sSteamID64));
		
		SteamWorks_SetHTTPRequestGetOrPostParameter(hRequest, "key", 		g_sAPIKey);
		SteamWorks_SetHTTPRequestGetOrPostParameter(hRequest, "steamids", 	sSteamID64);
		SteamWorks_SetHTTPCallbacks(hRequest, HTTPRequestComplete);
		SteamWorks_SetHTTPRequestContextValue(hRequest, GetClientSerial(iClient));
		
		SteamWorks_SendHTTPRequest(hRequest);

		return Plugin_Changed;
	}
	return (iReason == WHITE_LIST_REMOVE && g_bAccess[iClient]) ? Plugin_Stop:Plugin_Continue;
}


public void HTTPRequestComplete(Handle hRequest, bool bFailure, bool bRequestSuccessful, EHTTPStatusCode eStatusCode, any iClient)
{
	if(eStatusCode == k_EHTTPStatusCode200OK && (iClient = GetClientFromSerial(iClient)))
	{
		SteamWorks_GetHTTPResponseBodyCallback(hRequest, HTTPResponseBody, GetClientSerial(iClient));
	}
	delete hRequest;
}

public int HTTPResponseBody(const char[] sData, int iClient)
{
	if((iClient = GetClientFromSerial(iClient)) != 0)
	{
		char sBuffer[12];
		if(SplitString(sData[StrContains(sData, "\"timecreated\":")+14], ",", sBuffer, sizeof(sBuffer)) != -1)
		{
			int iTimecreated;
			if((iTimecreated = StringToInt(sBuffer)) != 0 && iTimecreated < GetTime()-g_iDays)
			{
				PN_SetPlayerStatus(iClient, WHITE_LIST, WHITE_LIST_ADD);
				g_bAccess[iClient] = true;
				return;
			}
		}
		PN_SetPlayerStatus(iClient, NO_PRIME, VERIFICATION_END);
	}
	return;
}

public void OnClientDissconect(int iClient)
{
	g_bAccess[iClient] = false;
}