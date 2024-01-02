# Money printer plugin
_delete this file after dowloading_

## Item creating
>Copy exemple exemple file(sh_printer_exemple.lua) from money_printer_plugin\items to oney_printer_plugin\items and rename your file(don't forget about sh_ in begining of file name). Then you need edit this file. You can edit this like default helix item, but you need write name of money printer entity in ITEM.PrinterEntity(6th line in exemple item)

>## Money printer entity creating
>Copy money_printer folder from money_printer_plugin\entities\entities\money_printer to money_printer_plugin\entities\entities and type your name of folder. This name that you must type in ITEM.PrinterEntity in item file.
>Then you need edit shared.lua with your setings.
>ENT.PrintName - name that will printed on placed printer
>ENT.Description - description that will printed on placed printer
>ENT.Spawnable - can somebody spawn it from Q - menu
>ENT.PrinterSound - sound that playing while printer is working
>ENT.PrinterModel - world model of printer
>ENT.PrinterInterval - interval between spawn of money in printer
>ENT.WarmInterval - how often add % of warm
>ENT.ColdInterval - how often diminish % of warm
>ENT.PerfomanceUpgades - table of tables, that has description of every Perfomance Upgade. Where "_profit_" is how many money spawn every ENT.PrinterInterval and where "_price_" is price of upgrade(_Check exemple file. You can make LVLs as much as you like_)
>ENT.ENT.WarmUpgades - table of tables, that has description of every Warm Upgade. Where "_WarmSpeed_" is how many % of warm soawn every ENT.WarmInterval and where "_price_" is price of upgrade(_Check exemple file. You can make LVLs as much as you like_)
>ENT.ReturnItem - item, that entity should return after pressing "Take" button
