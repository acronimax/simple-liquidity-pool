![image](https://img.shields.io/badge/Solidity-e6e6e6?style=for-the-badge&logo=solidity&logoColor=black)
![image](https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=Ethereum&logoColor=white)

# Simple Liquidity Pool

Los estudiantes deben desplegar contratos inteligentes en la red de Scroll Sepolia (verificados y publicados) para implementar un exchange descentralizado simple que intercambie dos tokens ERC-20.

La solución debe permitir:

- Añadir liquidez: El owner puede depositar pares de tokens en el pool para proporcionar liquidez.
- Intercambiar tokens: Los usuarios pueden intercambiar uno de los tokens por el otro utilizando el pool de liquidez.
- Retirar liquidez: El owner puede retirar sus participaciones en el pool.

## Requisitos:

1. Crear dos tokens ERC-20 simples: Los contrato de los tokens deben tener obligatoriamente los nombres TokenA y TokenB.

2. Implementar un contrato de exchange (denominado obligatoriamente SimpleDEX) que:

   - Mantenga un pool de liquidez para TokenA y TokenB.
   - Utilice la fórmula del producto constante (x+dx)(y-dy) = xy para calcular los precios de intercambio.
   - Permita añadir y retirar liquidez.
   - Permita intercambiar TokenA por TokenB y viceversa.

3. El contrato SimpleDEX debe contar obligatoriamente y sin modificación de la interface con las siguientes funciones:

- `constructor(address _tokenA, address _tokenB)`
- `addLiquidity(uint256 amountA, uint256 amountB)`
- `swapAforB(uint256 amountAIn)`
- `swapBforA(uint256 amountBIn)`
- `removeLiquidity(uint256 amountA, uint256 amountB)`
- `getPrice(address _token)`

4. Incluir los eventos que consideren convenientes.
