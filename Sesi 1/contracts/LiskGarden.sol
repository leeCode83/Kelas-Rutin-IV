// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract LiskGarden {
    // 1. Data Types
    enum GrowthStage { SEED, SPROUT, GROWING, BLOOMING }

    struct Plant { 
        uint256 id;
        address owner;
        GrowthStage stage;
        uint256 plantedDate;
        uint256 lastWatered;
        uint8 waterLevel;
        bool exists;
        bool isDead;
     }

    // 2. State
    mapping(uint256 => Plant) public plants;
    mapping(address => uint256[]) public userPlants;
    uint256 public plantCounter;
    address public owner;

    // 3. Constants
    uint256 constant PLANT_PRICE = 0.001 ether;
    uint256 constant HARVEST_REWARD = 0.003 ether;
    uint256 constant STAGE_DURATION = 1 minutes;
    uint256 constant WATER_DEPLETION_TIME = 30 seconds;
    uint256 constant WATER_DEPLETION_RATE = 2;

    // 4. Events
    event PlantSeeded(address indexed owner, uint256 indexed plantId);
    event PlantWatered(uint256 indexed plantId, uint8 newWaterLevel);
    event PlantHarvested(uint256 indexed plantId, address indexed owner, uint256 reward);
    event StageAdvanced(uint256 indexed plantId, GrowthStage newStage);
    event PlantDied(uint256 indexed plantId);

    // 5. Constructor
    constructor() { 
        owner = msg.sender;
    }

    // 6. Main Functions (8 functions)
    function plantSeed() external payable returns (uint256){ 
        require(msg.value >= PLANT_PRICE, "Incorrect amount sent");
        plantCounter++;
        plants[plantCounter] = Plant({
            id: plantCounter,
            owner: msg.sender,
            stage: GrowthStage.SEED,
            plantedDate: block.timestamp,
            lastWatered: block.timestamp,
            waterLevel: 100,
            exists: true,
            isDead: false
        });

        userPlants[msg.sender].push(plantCounter);
        emit PlantSeeded(msg.sender, plantCounter);
        return plantCounter;
    }

    function calculateWaterLevel(uint256 _plantId) public returns(uint8) { 
        require(_plantId <= plantCounter, "ID tidak valid");
        Plant memory plant = plants[_plantId];
        if(!plant.exists || plant.isDead) return 0;
        uint256 time = block.timestamp - plant.lastWatered;
        uint256 depletionInterval = time / WATER_DEPLETION_TIME;
        uint256 waterLost = depletionInterval * WATER_DEPLETION_RATE;

        updateWaterLevel(_plantId, uint8(plant.waterLevel - waterLost));

        if(waterLost > plant.waterLevel){ 
            emit PlantDied(_plantId);
            return 0;
        }

        return uint8(plant.waterLevel - waterLost);
    }

    function updateWaterLevel(uint256 _plantId, uint8 _newWaterLevel) internal {
        Plant storage plant = plants[_plantId];
        plant.waterLevel = _newWaterLevel;
        plant.lastWatered = block.timestamp;
    }

    function waterPlant(uint256 _plantId) external {
        Plant memory plant = plants[_plantId];
        plant.waterLevel = 100;
        updateWaterLevel(_plantId, plant.waterLevel);
        emit PlantWatered(_plantId, plant.waterLevel);
    }

    function updatePlantStage(uint256 _plantId) public {
        Plant storage plant = plants[_plantId];
        uint256 timeElapsed = block.timestamp - plant.plantedDate;
        if(timeElapsed >= 3 minutes){
            plant.stage = GrowthStage.BLOOMING;
        }else if(timeElapsed >= 2 minutes){
            plant.stage = GrowthStage.GROWING;
        }else if(timeElapsed >= 1 minutes){
            plant.stage = GrowthStage.SPROUT;
        }
    }

    function harvestPlant(uint256 _plantId) external {
        Plant storage plant = plants[_plantId];
        require(msg.sender == plant.owner);
        require(plant.exists, "Plant not exist");
        require(!plant.isDead, "Plant is dead");
        require(plant.stage == GrowthStage.BLOOMING, "Plant not ready to harvest");
        
        plant.exists = false;
        (bool success, ) = msg.sender.call{value: HARVEST_REWARD}("");
        
        require(success, "Transaksi gagal");
    }

    // // 7. Helper Functions (3 functions)
    function getPlant(uint256 _plantId) external view returns(Plant memory){
        require(_plantId <= plantCounter, "ID tidak valid");
        Plant memory plant = plants[_plantId];
        return plant;
    }

    function getUserPlants() external view returns(uint256[] memory){
        require(msg.sender != address(0), "Empty address");
        return userPlants[msg.sender];
    }

    function withdraw(address _to) external {
        require(msg.sender == owner, "Only owner");
        (bool success, ) = _to.call{value: address(this).balance}("");
        require(success, "Transfer gagal");
    }

    // // 8. Receive ETH
    receive() external payable {}

    function deposit() public payable {}
}