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
- `Melhoria Cash`: faz `Upgrade(1, false)`, `Upgrade(2, false)`, `Upgrade(2, true)` e `Upgrade(3, false)` em sequencia
- Tecla padrao: `G`

## Proximos remotos

Me passe os proximos eventos que eu adiciono como novos botoes nessa mesma GUI.
