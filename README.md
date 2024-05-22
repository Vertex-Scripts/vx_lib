# VX Lib

Modules, utilities, and wrappers around ESX and QBCore.

## Configuration
You can configure the following settings in your `server.cfg`:

- `vx:framework` - The framework to use. `esx`, `qb`, or `auto`.
- `vx:inventory` - The inventory to use. `ox_inventory`, `qb_inventory`, `es_extended`, `qs_inventory` or `auto`.
- `vx:target` - The target to use. `ox_target`, `qb_target`, `qtarget` or `auto`.
- `vx:primaryIdentifier` - The primary identifier to use. `license`, `steam` or `auto`
- `vx:notification` - The notification system to use. `ox`, `esx`, `qb`, or `custom`.

## Server Wrappers

### Inventory

- [x] es_extended
- [x] qb-inventory
- [x] ox_inventory
- [x] qs-inventory

#### Functions

- `vx.inventory.addItem(source: number, item: string, count?: number)`
- `vx.inventory.removeItem(source: number, item: string, count?: number)`
- `vx.inventory.getItemCount(source: number, item: string)`
- `vx.inventory.hasItem(source: number, item: string, count?: number)`

### Player

- [x] es_extended
- [x] qb-core
- [ ] vrp

#### Functions

- `vx.player.getFromId(source: number)`
- `player:addAccountMoney(account: "bank" | "cash", amount: number, reason?: string)`
- `player:setJob(name: string, grade: number)`

## Client Wrappers

### Target

- [x] ox_target
- [x] qb-target
- [ ] qtarget

#### Options

#### Structures

`TargetOptions`:

```kotlin
label: string
icon?: string
distance?: number
onSelect fun(data: table)
canInteract fun(data: table): boolean
```

`EntityTargetOptions : TargetOptions`:

```lua
onSelect? fun(data: { entity: number })
canInteract? fun(data: { entity: number }): boolean
```

#### Functions

- `vx.target.addGlobalVehicle(options)`
- `vx.target.addGlobalPlayer(options)`
- `vx.target.addGlobalPed(options)`
- `vx.target.removeGlobalVehicle(options)`
- `vx.target.removeGlobalPlayer(options)`
- `vx.target.removeGlobalPed(options)`
- `vx.target.addModel(models, options)`
- `vx.target.removeModel(options)`
