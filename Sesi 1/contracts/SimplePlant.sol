// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// 1. water()
//    - Tipe: public
//    - Aksi: Set waterLevel kembali ke 100

// 2. getAge()
//    - Tipe: public view
//    - Return: uint256
//    - Aksi: Hitung umur tanaman (waktu sekarang - waktu tanam)

contract SimplePlant{
    string public plantName;
    uint256 public waterLevel;
    bool public isLive;
    address public owner;
    uint256 public plantedTime;

    constructor(){
        plantName = "Rose";
        waterLevel = 100;
        isLive = true;
        owner = msg.sender;
        plantedTime = block.timestamp;
    }

    function water() public {
        waterLevel = 100;
    }

    function getAge() public view returns(uint256){
        return block.timestamp - plantedTime;
    }

}