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

## Link fixo recomendado

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/marcoscarneiroaj/moneycash/main/loader.lua", true))()
```

Esse `loader.lua` usa cache bust interno para puxar a versao mais nova do `moneycash.lua` sem voce precisar trocar a URL.

## Eventos atuais

- `Click Money`: faz `game:GetService("ReplicatedStorage").Events.ClickMoney:FireServer()`
- Botao na GUI para ligar e desligar
- Tecla padrao: `F`
- Delay padrao: `0.01`
- `Melhoria Cash`: faz `Upgrade(1, false)`, `Upgrade(2, false)`, `Upgrade(2, true)` e `Upgrade(3, false)` em sequencia
- Tecla padrao: `G`
- `Prestigio`: faz `game:GetService("ReplicatedStorage").Events.Prestige:FireServer()`
- Tecla padrao: `H`
- `Arvore de Prestigio`: faz `PrestigeUpgrade(2)`, `PrestigeUpgrade(9)`, `PrestigeUpgrade(1)`, `PrestigeUpgrade(31)`, `PrestigeUpgrade(11)`, `PrestigeUpgrade(3)` e `PrestigeUpgrade(28)` em sequencia
- Tecla padrao: `J`
- `Delete`: minimiza ou mostra a GUI

## Proximos remotos

Me passe os proximos eventos que eu adiciono como novos botoes nessa mesma GUI.
