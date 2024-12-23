// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Alquiler {
    
    address public ownerPlaza;
    uint public idPlaza;
    address public inquilino;
    uint256 public inicioAlquiler;
    uint256 public duracionAlquiler;
    uint256 public montoAlquiler;
    bool public alquilado;
    uint public balanceAlquiler;

    event AlquilerIniciado(address indexed inquilino, uint idPlaza, uint256 inicioAlquiler, uint256 duracionAlquiler, uint256 montoAlquiler);
    event AlquilerFinalizado(address indexed inquilino, uint idPlaza, uint256 finAlquiler);

    modifier soloOwner() {
        require(msg.sender == ownerPlaza, "Solo el propietario puede ejecutar esta funcion");
        _;
    }

    modifier soloInquilino() {
        require(msg.sender == inquilino, "Solo el inquilino puede ejecutar esta funcion");
        _;
    }

    constructor() {
        // empty
    }

    function iniciarAlquiler(address _ownerPlaza, uint _idplaza, uint256 _duracionAlquiler, uint256 _montoAlquiler) public payable  {
        require(!alquilado, "Ya hay un alquiler en curso");

        require(msg.value == _montoAlquiler, "El precio enviado tiene que ser igual al precio del alquiler");

        ownerPlaza = _ownerPlaza;
        inquilino = msg.sender;
        idPlaza = _idplaza;
        inicioAlquiler = block.timestamp;
        duracionAlquiler = _duracionAlquiler;
        montoAlquiler = _montoAlquiler;
        alquilado = true;
        balanceAlquiler = msg.value;

        emit AlquilerIniciado(inquilino, _idplaza, inicioAlquiler, duracionAlquiler, montoAlquiler);
    }

    function finalizarAlquiler() public {
        require(alquilado, "No hay un alquiler en curso");
        require(block.timestamp >= inicioAlquiler + duracionAlquiler, "El tiempo de alquiler no ha terminado");
        alquilado = false;
        payable(ownerPlaza).transfer(balanceAlquiler);
        montoAlquiler = 0;
        emit AlquilerFinalizado(inquilino, idPlaza, block.timestamp);
    }
}