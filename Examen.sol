// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

contract Examen {

    uint8 constant public minNota = 4;
    
    address public owner;

    mapping (address => Alumno) public alumnos;

    struct Alumno {
        bool corregido;
        bool aprobado;
        uint8 nota;
    }

    constructor () {
        owner = msg.sender;
    }

    function ponerNota(address idAlumno, uint8 nota) public {
        require(msg.sender == owner);
        alumnos[idAlumno].corregido = true;
        alumnos[idAlumno].nota = nota;
        if (alumnos[idAlumno].nota >= minNota) {
            alumnos[idAlumno].aprobado = true;
        }
    }

}