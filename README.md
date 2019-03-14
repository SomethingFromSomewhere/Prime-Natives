# [Core] Prime Natives
Core for control non Prime players for CS:GO.

###### Requires [SteamWorks](https://github.com/KyleSanderson/SteamWorks/).

## [Account Lifetime](https://github.com/SomethingFromSomewhere/Prime-Natives/blob/master/Prime_Natives_Account_Lifetime.sp)

Module for check player account registarion date.

>**sm_prime_natives_account_lifetime_minimum_days** - Minimum account lifetime by days. 31 default.
>**sm_prime_natives_account_lifetime_api_key** - Steam WEB Api Key.

## [Admin Access](https://github.com/SomethingFromSomewhere/Prime-Natives/blob/master/Prime_Natives_Admin_Access.sp)

Provides access for users without **Prime** who has admin access.

>**sm_prime_natives_admin_access** - command for oveeride in **admin_overrides.cfg**.

## [Steam Group Access](https://github.com/SomethingFromSomewhere/Prime-Natives/blob/master/Prime_Natives_Steam_Group_Access.sp)

Provides access for users without **Prime** who joined steam group.

###### Requires [SWGM](https://github.com/SomethingFromSomewhere/SWGM).

>**sm_prime_natives_swgm_type** - 1 - access for all group users. 0 access for admins and moderators."

## [VIP Access](https://github.com/SomethingFromSomewhere/Prime-Natives/blob/master/Prime_Natives_VIP_Access.sp)

Provides access for users without **Prime** who has **VIP** (by **R1KO**) status.

###### Requires [VIP](https://github.com/R1KO/VIP-Core).

>**sm_prime_natives_vip_access_group** - Group, that gives access. Leave empty for all.

## [TAG](https://github.com/SomethingFromSomewhere/Prime-Natives/blob/master/Prime_Natives_Tag.sp)

Force clan tag for non **Prime** users.

>**sm_prime_natives_clan_tag** - Tag for users without **Prime** status. **[No Prime]** is default.

## [Kick](https://github.com/SomethingFromSomewhere/Prime-Natives/blob/master/Prime_Natives_Kick.sp)

Kick all users without **Prime** status and white list access.
