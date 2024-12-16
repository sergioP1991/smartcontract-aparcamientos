// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Alquiler {
    
    address public owner;
    string public idPlaza;
    address public inquilino;
    uint256 public inicioAlquiler;
    uint256 public duracionAlquiler;
    uint256 public montoAlquiler;
    bool public alquilado;

    event AlquilerIniciado(address indexed inquilino, string idPlaza, uint256 inicioAlquiler, uint256 duracionAlquiler, uint256 montoAlquiler);
    event AlquilerFinalizado(address indexed inquilino, string idPlaza, uint256 finAlquiler);

    modifier soloOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion");
        _;
    }

    modifier soloInquilino() {
        require(msg.sender == inquilino, "Solo el inquilino puede ejecutar esta funcion");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function iniciarAlquiler(address _inquilino, string calldata _idplaza, uint256 _duracionAlquiler, uint256 _montoAlquiler) public soloOwner {
        require(!alquilado, "Ya hay un alquiler en curso");
        inquilino = _inquilino;
        idPlaza = _idplaza;
        inicioAlquiler = block.timestamp;
        duracionAlquiler = _duracionAlquiler;
        montoAlquiler = _montoAlquiler;
        alquilado = true;
        emit AlquilerIniciado(inquilino, _idplaza, inicioAlquiler, duracionAlquiler, montoAlquiler);
    }

    function finalizarAlquiler() public {
        require(alquilado, "No hay un alquiler en curso");
        require(block.timestamp >= inicioAlquiler + duracionAlquiler, "El tiempo de alquiler no ha terminado");
        alquilado = false;
        emit AlquilerFinalizado(inquilino, idPlaza, block.timestamp);
    }

    function pagarAlquiler() public payable soloInquilino {
        require(alquilado, "No hay un alquiler en curso");
        require(msg.value == montoAlquiler, "Monto de alquiler incorrecto");
        payable(owner).transfer(msg.value);
    }
}
