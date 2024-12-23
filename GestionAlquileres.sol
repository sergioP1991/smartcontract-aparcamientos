// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./model/Alquiler.sol"; // Asegúrate de que la ruta al contrato Alquiler.sol sea correcta

contract GestionAlquileres {

    address public owner;
    uint public numAlquileres;
    mapping(address => uint) public alquileresPorOwner;
    mapping(uint => Alquiler) public alquileres;

    event AlquilerCreado(address indexed contratoAlquiler, address indexed owner, uint idPlaza);

    modifier soloOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
    
    function crearAlquiler(
        address ownerPlaza,
        uint _idplaza,
        uint256 _duracionAlquiler,
        uint256 _montoAlquiler
    ) public payable {
        require(msg.sender != owner, "El owner del contrato no puede alquilar la plaza");

        Alquiler nuevoAlquiler = new Alquiler();
        nuevoAlquiler.iniciarAlquiler{value: _montoAlquiler}(ownerPlaza, _idplaza, _duracionAlquiler, _montoAlquiler);
        alquileres[_idplaza] = nuevoAlquiler;
        numAlquileres++;
        alquileresPorOwner[msg.sender]++;

        emit AlquilerCreado(address(nuevoAlquiler), msg.sender, _idplaza);
    }

    function getAlquileres() public view returns (address[] memory){

        address[] memory ret = new address[](numAlquileres);
        for (uint i = 0; i < numAlquileres; i++) {
            ret[i] = address(alquileres[i]);
        }
        return ret;

    }

    function getAlquiler(uint alquiler) public view returns (Alquiler){
      return alquileres[alquiler];
    }

    function getAlquileresPorOwner(address ownerAddres) public view returns (uint){
        return alquileresPorOwner[ownerAddres];
    }

    function getNumAlquileres() public view returns (uint) {
        return numAlquileres;
    }

    function withdraw() public soloOwner {
        require(address(this).balance > 0 , "No hay fondos en el contrato");
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Error en la transferencia");
    }

    function finalizarAlquiler(uint alquiler) public {
        alquileres[alquiler].finalizarAlquiler();
    }
}