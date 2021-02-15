-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 09, 2021 at 03:55 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `modelo_web`
--

-- --------------------------------------------------------

--
-- Table structure for table `t_contas`
--

CREATE TABLE `t_contas` (
  `ID` int(11) NOT NULL,
  `CONTA` varchar(30) CHARACTER SET latin1 NOT NULL,
  `SALDO` double NOT NULL,
  `DC` varchar(1) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `t_contas`
--

INSERT INTO `t_contas` (`ID`, `CONTA`, `SALDO`, `DC`) VALUES
(1, 'RECEITAS', 0, 'D'),
(2, 'DESPESAS', 0, 'C'),
(3, 'VENDAS A VISTA (DINHEIRO)', 0, 'D'),
(4, 'VENDAS A PRAZO (CARTÃO DE CRÉD', 0, 'D'),
(5, 'ÁGUA, LUZ, TELEFONE E INTERNET', 0, 'C'),
(6, 'FOLHA DE PAGTO - FUNCIONARIOS', 0, 'C'),
(7, 'TAXAS E IMPOSTOS', 0, 'C'),
(8, 'MATERIAL DE LIMPEZA', 0, 'C'),
(9, 'PRODUTOS DE COPA E ARMARINHO', 0, 'C'),
(10, 'OUTRAS DESPESAS, ETC', 0, 'C');

-- --------------------------------------------------------

--
-- Table structure for table `t_fornecedores`
--

CREATE TABLE `t_fornecedores` (
  `ID` int(11) NOT NULL,
  `FORNECEDOR` varchar(35) CHARACTER SET latin1 NOT NULL,
  `EMAIL` varchar(60) CHARACTER SET latin1 NOT NULL,
  `TELEFONE` varchar(18) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `t_fornecedores`
--

INSERT INTO `t_fornecedores` (`ID`, `FORNECEDOR`, `EMAIL`, `TELEFONE`) VALUES
(1, 'RM DISTRIBUIDORA LTDA', 'contato@rmdistribuidora.com.br', '(31) 98080-0000'),
(2, 'ABC ATACADO E VAREJO LTDA', 'contato@abcatacado.com.br', '(31) 0800-113-000'),
(3, 'COMERCIAL JM LTDA', 'comercialjm@gmail.com', '(31) 4040-8000');

-- --------------------------------------------------------

--
-- Table structure for table `t_itensdevenda`
--

CREATE TABLE `t_itensdevenda` (
  `ID` int(11) NOT NULL,
  `ID_VENDA` int(11) NOT NULL,
  `ID_PRODUTO` int(11) NOT NULL,
  `QTD` int(11) NOT NULL,
  `VALOR_UN` double NOT NULL,
  `VALOR_TOTAL` double NOT NULL,
  `ID_USUARIO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `t_itensdevenda`
--

INSERT INTO `t_itensdevenda` (`ID`, `ID_VENDA`, `ID_PRODUTO`, `QTD`, `VALOR_UN`, `VALOR_TOTAL`, `ID_USUARIO`) VALUES
(1, 1, 47, 2, 1.99, 3.98, 1),
(2, 1, 34, 1, 7.5, 7.5, 1),
(3, 1, 36, 1, 10, 10, 1),
(4, 2, 34, 2, 7.5, 15, 1),
(5, 2, 18, 1, 29.99, 29.99, 1),
(6, 3, 34, 1, 7.5, 7.5, 2);

-- --------------------------------------------------------

--
-- Table structure for table `t_lancamentos`
--

CREATE TABLE `t_lancamentos` (
  `ID` int(11) NOT NULL,
  `DATA` date NOT NULL,
  `HISTORICO` varchar(100) CHARACTER SET latin1 NOT NULL,
  `VALOR` double(10,2) NOT NULL,
  `TIPO` varchar(1) CHARACTER SET latin1 NOT NULL,
  `ID_USUARIO` int(11) NOT NULL,
  `ID_CONTA` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `t_lancamentos`
--

INSERT INTO `t_lancamentos` (`ID`, `DATA`, `HISTORICO`, `VALOR`, `TIPO`, `ID_USUARIO`, `ID_CONTA`) VALUES
(1, '2020-12-13', 'RECEITAS C/ VENDAS EM DINHEIRO', 1500.00, 'D', 0, 1),
(2, '2020-12-13', 'RECEITAS C/ CARTAO DE CREDITO', 800.00, 'D', 0, 4),
(3, '2020-12-13', 'PGTO CEMIG', 138.55, 'C', 0, 5),
(4, '2020-12-01', 'PGTO FORNEC. GÁS', 188.00, 'C', 0, 2),
(5, '2020-12-12', 'PGTO VALE FUNCIONARIOS', 150.00, 'C', 0, 6),
(6, '2020-12-12', 'DESPESAS C/ MATERIAL DE LIMPEZA', 80.00, 'C', 0, 8),
(8, '2020-12-15', 'VENDAS A VISTA', 1885.00, 'D', 0, 1),
(13, '2020-12-16', 'PAGO ISS/COFINS', 185.00, 'C', 0, 7),
(14, '2020-12-26', 'PAGO CONTA LUZ CEMIG REF. DEZEMBRO DE 2020', 135.00, 'C', 0, 5),
(15, '2020-12-29', 'VENDA Nº 000001 - EZEQUIAS MARTINS', 21.48, 'D', 1, 1),
(16, '2020-12-29', 'VENDA Nº 000002 - EZEQUIAS MARTINS', 44.99, 'D', 1, 1),
(17, '2020-12-29', 'VENDA Nº 000003 - JOSÉ CARLOS', 7.50, 'D', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_produtos`
--

CREATE TABLE `t_produtos` (
  `ID` int(11) NOT NULL,
  `PRODUTO` varchar(35) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `IMAGEM` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `ESTQ_ATUAL` int(11) NOT NULL,
  `UNIDADE` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `VALOR` double(10,2) NOT NULL,
  `ID_FORNECEDOR` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `t_produtos`
--

INSERT INTO `t_produtos` (`ID`, `PRODUTO`, `IMAGEM`, `ESTQ_ATUAL`, `UNIDADE`, `VALOR`, `ID_FORNECEDOR`) VALUES
(14, 'LASANHA BOLONHESA', '000014.jpg', 9, 'UN', 18.00, 3),
(18, 'PORÇÃO FRANGO PASSARINHO C/ FRITAS', '000018.jpg', 5, 'PC', 29.99, 2),
(19, 'GUARANÁ ANTÁRTICA LATA 350 ML', '000019.jpg', 80, 'UN', 5.00, 1),
(22, 'WHISKY OLD EIGTH (DOSE)', '000054.jpg', 99, 'UN', 7.00, 1),
(34, 'CERVEJA LATA 350 ML', '000034.jpg', 174, 'UN', 7.50, 2),
(36, 'HAMBÚGUER ', '000036.jpg', 13, 'UN', 10.00, 2),
(38, 'COCA COLA LATA 350 ML', '000038.jpg', 75, 'UN', 5.00, 1),
(39, 'LASANHA 4 QUEIJOS', '000039.jpg', 13, 'UN', 18.00, 3),
(46, 'CHEESEBURGUER', '000046.jpg', 98, 'UN', 1.99, 2),
(47, 'ÁGUA MINERAL SEM GÁS 200ML', '000047.jpg', 72, 'UN', 3.00, 1),
(48, 'ÁGUA MINERAL GASOSA 300 ML', '000048.jpg', 96, 'UN', 4.50, 2);

-- --------------------------------------------------------

--
-- Table structure for table `t_usuarios`
--

CREATE TABLE `t_usuarios` (
  `ID` int(11) NOT NULL,
  `NOME` varchar(35) CHARACTER SET latin1 NOT NULL,
  `FUNCAO` varchar(18) CHARACTER SET latin1 NOT NULL,
  `USUARIO` varchar(20) CHARACTER SET latin1 NOT NULL,
  `SENHA` varchar(100) CHARACTER SET latin1 NOT NULL,
  `NIVEL` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `t_usuarios`
--

INSERT INTO `t_usuarios` (`ID`, `NOME`, `FUNCAO`, `USUARIO`, `SENHA`, `NIVEL`) VALUES
(1, 'SUPORTE', 'SUPORTE TÉCNICO', 'suporte', '*4CB947971FACB7AB4E93FAF2078DD186A4C91A46', 5),
(2, 'GERENTE', 'GERÊNCIA/ADM', 'gerente', '*4CB947971FACB7AB4E93FAF2078DD186A4C91A46', 3),
(3, 'USUÁRIO', 'OPERAÇÃO/USUÁRIO', 'usuario', '*4CB947971FACB7AB4E93FAF2078DD186A4C91A46', 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_vendas`
--

CREATE TABLE `t_vendas` (
  `ID` int(11) NOT NULL,
  `ID_USUARIO` int(11) NOT NULL,
  `DATA` date NOT NULL,
  `VALOR_TOTAL` double(10,2) NOT NULL,
  `CHV` varchar(1) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `t_vendas`
--

INSERT INTO `t_vendas` (`ID`, `ID_USUARIO`, `DATA`, `VALOR_TOTAL`, `CHV`) VALUES
(1, 1, '2020-12-29', 21.48, 'F'),
(2, 1, '2020-12-29', 44.99, 'F'),
(3, 2, '2020-12-29', 7.50, 'F');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `t_contas`
--
ALTER TABLE `t_contas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `t_fornecedores`
--
ALTER TABLE `t_fornecedores`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `t_itensdevenda`
--
ALTER TABLE `t_itensdevenda`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `t_lancamentos`
--
ALTER TABLE `t_lancamentos`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `t_produtos`
--
ALTER TABLE `t_produtos`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `t_usuarios`
--
ALTER TABLE `t_usuarios`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `t_vendas`
--
ALTER TABLE `t_vendas`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `t_contas`
--
ALTER TABLE `t_contas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `t_fornecedores`
--
ALTER TABLE `t_fornecedores`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `t_itensdevenda`
--
ALTER TABLE `t_itensdevenda`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `t_lancamentos`
--
ALTER TABLE `t_lancamentos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `t_produtos`
--
ALTER TABLE `t_produtos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `t_usuarios`
--
ALTER TABLE `t_usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `t_vendas`
--
ALTER TABLE `t_vendas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
