# moneycash

Projeto novo e separado, reaproveitando apenas a GUI base do projeto anterior.

## Rodar localmente

```lua
loadstring(readfile("moneycash\\moneycash.lua"), "@moneycash\\moneycash.lua")()
```

## Rodar pelo GitHub Raw

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/marcoscarneiroaj/moneycash/main/moneycash.lua", true))()
```

## Eventos atuais

- `Click Money`: faz `game:GetService("ReplicatedStorage").Events.ClickMoney:FireServer()`
- Botao na GUI para ligar e desligar
- Tecla padrao: `F`
- Delay padrao: `0.01`
- `Upgrade 1`: faz `game:GetService("ReplicatedStorage").Events.Upgrade:FireServer(1, false)`
- Tecla padrao: `G`
- `Upgrade 2`: faz `game:GetService("ReplicatedStorage").Events.Upgrade:FireServer(2, false)`
- Tecla padrao: `H`
- `Upgrade 2 Max`: faz `game:GetService("ReplicatedStorage").Events.Upgrade:FireServer(2, true)`
- Tecla padrao: `J`

## Proximos remotos

Me passe os proximos eventos que eu adiciono como novos botoes nessa mesma GUI.
