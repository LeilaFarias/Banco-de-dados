
CREATE TABLE farmacias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(20),
    unidade VARCHAR(6),
    bairro VARCHAR(50) UNIQUE,
    estado ESTADO,
    gerente_cpf VARCHAR(11),
    gerente_funcao VARCHAR(1),

    FOREIGN KEY (gerente_cpf, gerente_funcao) REFERENCES funcionarios(cpf, funcao),
    CONSTRAINT exc_uma_sede EXCLUDE USING gist (unidade WITH = ) WHERE (unidade = 'sede'),
    CONSTRAINT chk_unidade CHECK (unidade IN ('sede','filial')),
    CONSTRAINT chk_gerente_funcao CHECK (gerente_funcao IN ('A', 'F'))
);

CREATE TYPE ESTADO AS ENUM ('PB','AL','BA','CE','MA','PN','PI','RN','SE');

CREATE TABLE funcionarios (
    nome VARCHAR(50),
    cpf VARCHAR(11) PRIMARY KEY,
    funcao VARCHAR(1),
    id_farmacia SERIAL REFERENCES farmacias(id),
    UNIQUE(cpf, funcao),

    CONSTRAINT chk_funcao CHECK (funcao IN ('F','V','E','C','A')) -- F = Farmaceutico, V = Vendedor, E = Entregador, C = caixa, A = administrador
);

CREATE TABLE cliente_endereco (
    id SERIAL PRIMARY KEY,
    cliente VARCHAR(11) REFERENCES clientes(cpf),
    tipo_endereco VARCHAR(15),
    cep VARCHAR(8),
    rua VARCHAR(50),
    bairro VARCHAR(50),
    numero INTEGER,

    CONSTRAINT chk_tipo_endereco CHECK (tipo_endereco IN ('R','T','O')) -- R = residencia, T = Trabalho, O = outro
)

CREATE TABLE medicamentos (
    id SERIAL,
    exclusivo_receita VARCHAR(1), -- null caso nao seja exclusivo, 'R' caso seja exclusivo
    UNIQUE(id, exclusivo_receita),

    CONSTRAINT chk_exclusivo_receita CHECK (exclusivo_receita = 'R' OR exclusivo_receita IS NULL)
);


CREATE TABLE vendas (
    funcionario VARCHAR(11),
    funcionario_funcao VARCHAR(1),
    medicamento SERIAL,
    med_exclusivo_receita VARCHAR(1),
    entrega_id SERIAL REFERENCES entregas(id), -- null caso não tenha sido por entrega
    cliente VARCHAR(11) REFERENCES clientes(cpf), -- null caso seja entrega

    FOREIGN KEY (medicamento, med_exclusivo_receita) REFERENCES medicamentos(id, exclusivo_receita) ON DELETE RESTRICT,
    FOREIGN KEY (funcionario, funcionario_funcao) REFERENCES funcionarios(cpf, funcao) ON DELETE RESTRICT,
    CONSTRAINT chk_receita_cliente CHECK (med_exclusivo_receita != 'R' OR (entrega_id IS NOT NULL OR cliente IS NOT NULL)),
    CONSTRAINT chk_funcao CHECK (funcionario_funcao = 'V'),
    CONSTRAINT chk_entrega_ou_cliente CHECK ((entrega_id is NULL OR cliente IS NULL))
);

CREATE TABLE entregas (
    id SERIAL PRIMARY KEY,
    id_endereco SERIAL REFERENCES cliente_endereco(id)

);

CREATE TABLE clientes (
    nome VARCHAR(50),
    cpf VARCHAR(11) PRIMARY KEY,
    data_nascimento DATE NOT NULL,

    CONSTRAINT chk_idade CHECK ((DATE_PART('YEAR', AGE(CURRENT_DATE, data_nascimento)) >= 18))
);

-- COMANDOS ADICIONAIS
--
-- DEVEM SER EXECUTADOS COM SUCESSO:
-- INSERT INTO funcionarios(nome, cpf, funcao, id_farmacia) VALUES('Rogerio', '12345678900', 'A', 100);
-- INSERT INTO farmacias(id, nome, unidade, bairro, estado, gerente_cpf, gerente_funcao) VALUES(100, 'redepharma', 'sede', 'bessa', 'PB', '12345678900', 'A');
-- INSERT INTO funcionarios(nome, cpf, funcao, id_farmacia) VALUES('Lucas', '12345678901', 'V', 100);
-- INSERT INTO funcionarios(nome, cpf, funcao, id_farmacia) VALUES('Bulma', '12345678902', 'F', 100);
-- INSERT INTO funcionarios(nome, cpf, funcao, id_farmacia) VALUES('Picollo', '12345678903', 'E', 100);
-- INSERT INTO funcionarios(nome, cpf, funcao, id_farmacia) VALUES('Raditz', '12345678904', 'A', 101);
-- INSERT INTO farmacias(id, nome, unidade, bairro, estado, gerente_cpf, gerente_funcao) VALUES(101, 'pagueMais', 'filial', 'Mangabeira', 'PB', '12345678904', 'A');
-- INSERT INTO farmacias(id, nome, unidade, bairro, estado, gerente_cpf, gerente_funcao) VALUES(102, 'pagueMais', 'filial', 'Bancarios', 'PB', null, null);

-- INSERT INTO clientes(nome, cpf, data_nascimento) VALUES('Kuririn','12365477799','2000-08-10')
-- INSERT INTO clientes(nome, cpf, data_nascimento) VALUES('Saitama','12365477700','1999-08-10')

-- INSERT INTO medicamentos(id, exclusivo_receita) VALUES(100, 'R');
-- INSERT INTO medicamentos(id, exclusivo_receita) VALUES(101, null);

-- INSERT INTO cliente_endereco(id, cliente, tipo_endereco, cep, rua, bairro, numero) VALUES (100, '12365477799', 'T', '89778900', 'Rua Alguma aí', 'Mangabeira', 35);

-- INSERT INTO entregas(id, id_endereco) VALUES (1, 100);

-- INSERT INTO vendas(funcionario, funcionario_funcao, medicamento, med_exclusivo_receita, entrega_id, cliente) VALUES ('12345678901', 'V', 100, 'R', 1, null);
-- INSERT INTO vendas(funcionario, funcionario_funcao, medicamento, med_exclusivo_receita, entrega_id, cliente) VALUES ('12345678901', 'V', 100, 'R', null, '12365477700');
-- INSERT INTO vendas(funcionario, funcionario_funcao, medicamento, med_exclusivo_receita, entrega_id, cliente) VALUES ('12345678901', 'V', 100, null, null, null);
-- 

-- NÃO DEVEM SER EXECUTADOS:
-- viola a constraint "exc_uma_sede" uma vez que pode haver apenas uma sede:
-- INSERT INTO farmacias(id, nome, unidade, bairro, estado, gerente_cpf, gerente_funcao) VALUES(110, 'redepharma', 'sede', 'Mangabeira', 'PB', '12345678902', 'F');
--
-- violar a constraint "chk_gerente_funcao" uma vez que a função gerente apenas pode ser A ou F:
-- INSERT INTO farmacias(id, nome, unidade, bairro, estado, gerente_cpf, gerente_funcao) VALUES(110, 'pagueMais', 'filial', 'Mangabeira', 'PB', '12345678901', 'V');
-- INSERT INTO farmacias(id, nome, unidade, bairro, estado, gerente_cpf, gerente_funcao) VALUES(110, 'pagueMais', 'filial', 'Mangabeira', 'PB', '12345678902', 'E');

-- viola a constraint "UNIQUE(bairro)" uma vez que só pode haver uma farmacia por bairro:
-- INSERT INTO farmacias(id, nome, unidade, bairro, estado, gerente_cpf, gerente_funcao) VALUES(110, 'pagueMais', 'filial', 'Bancarios', 'PB', null, null);

-- viola a constraint "chk_idade" uma vez que só pode ter cadastro quem é maior de 18:
-- INSERT INTO clientes(nome, cpf, data_nascimento) VALUES('Kuririn','12365477798','2018-08-10')

-- viola a constraint "chk_receita_cliente" onde se o medicamento só é vendido com receita, nao pode ser vendido a cliente sem cadastro:
-- INSERT INTO vendas(funcionario, funcionario_funcao, medicamento, med_exclusivo_receita, entrega_id, cliente) VALUES ('12345678901', 'V', 100, 'R', null, null);

-- viola a constraint "chk_entrega_ou_cliente" onde o medicamento só pode ser registrado como entrega ou retirada na loja (registrando o cpf do cliente que comprou), e nunca os dois ao mesmo tempo (manter integridade):
-- INSERT INTO vendas(funcionario, funcionario_funcao, medicamento, med_exclusivo_receita, entrega_id, cliente) VALUES ('12345678901', 'V', 100, 'R', 100, '12365477700');

-- viola a constraint "chk_funcao" uma vez que o medicamento só pode ser vendido por um funcionario vendedor:
-- INSERT INTO vendas(funcionario, funcionario_funcao, medicamento, med_exclusivo_receita, entrega_id, cliente) VALUES ('12345678901', 'A', 100, null, null, null);