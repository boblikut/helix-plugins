# Money printer plugin
_delete README.md file after dowloading_

## Item creating
>Copy exemple file(sh_printer_exemple.lua) from money_printer_plugin\items to oney_printer_plugin\items and rename your file(don't forget about sh_ in begining of file name). Then you need edit this file. You can edit this like default helix item, but you need write name of money printer entity in ITEM.PrinterEntity(6th line in exemple item)

## Money printer entity creating
> Copy money_printer folder from money_printer_plugin\entities\entities\money_printer to money_printer_plugin\entities\entities and type your name of folder. This name that you must type in ITEM.PrinterEntity in item file. Then you need edit shared.lua with your setings:
>* __ENT.PrintName__ - name that will printed on placed printer
>* __ENT.Description__ - description that will printed on placed printer
>* __ENT.Spawnable__ - can somebody spawn it from Q - menu
>* __ENT.PrinterSound__ - sound that playing while printer is working
>* __ENT.PrinterModel__ - world model of printer
>* __ENT.PrinterInterval__ - interval between spawn of money in printer
>* __ENT.WarmInterval__ - how often add % of warm
>* __ENT.ColdInterval__ - how often diminish % of warm
>* __ENT.EnergyInterval__ - how often diminish % of energy
>* __ENT.PrinterHealths__ - HP of printer
>* __ENT.PerfomanceUpgades__ - table of tables, that has description of every Perfomance Upgade. Where "_profit_" is how many money spawn every ENT.PrinterInterval and where "_price_" is price of upgrade(_Check exemple file. You can make LVLs as much as you like_)
>* __ENT.ENT.WarmUpgades__ - table of tables, that has description of every Warm Upgade. Where "_WarmSpeed_" is how many % of warm soawn every ENT.WarmInterval and where "_price_" is price of upgrade(_Check exemple file. You can make LVLs as much as you like_)
>* __ENT.ReturnItem__ - item, that entity should return after pressing "Take" button
>* __ENT.RebootPrice__ - price of printer reboot

### Change log
>* __02.01.2024__ - plugin created
>* __03.01.2024__ - added energy and reboot system
>* __03.01.2024__(5 PM +3 GTM) - security fix(thanks Evgeny Akabenko, Phoenixf, TankNut)
>* __09.01.2024__ - Amogus Fix(thanks Vondar(Umoritelno))  
