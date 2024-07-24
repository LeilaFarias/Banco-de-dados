CREATE TABLE farmacias (
    id INTEGER PRIMARY KEY,
    unidade VARCHAR(6),
    funcionarios_lotados VARCHAR(11) UNIQUE,
    gerente 

    CONSTRAINT fk_func_lotados FOREIGN KEY (funcionarios_lotados) REFERENCES funcionarios(cpf),
    
    CONSTRAINT exc_um_gerente EXCLUDE USING gist (funcionarios_lotados with =) WHERE (funcionarios_lotados = 'administrador')
    CONSTRAINT chk_famarcia CHECK (farmacia IN ('sede','filial'))
);

CREATE TABLE funcionarios (
    cpf VARCHAR(11) PRIMARY KEY,
    funcao VARCHAR(1),
    gerente BOOLEAN,
    

    CONSTRAINT chk_funcao CHECK (funcao IN ('F','V','E','C','A')) -- F = Farmaceutico, V = Vendedor, E = Entregador, C = caixa, A = administrador
);

CREATE TABLE cliente_endereco (
    cpf_cliente VARCHAR(11) PRIMARY KEY,
    tipo_endereco VARCHAR(15),

    CONSTRAINT chk_tipo_endereco CHECK (tipo_endereco IN ('residência','trabalho','outro')),


)

CREATE TABLE medicamentos (
    exclusivo_receita BOOLEAN,

);

CREATE TABLE vendas (

);

CREATE TABLE entregas (
    cliente VARCHAR(11) REFERENCES 
);

CREATE TABLE clientes (
    cpf VARCHAR(11) REFERENCES cliente_endereco(cpf_cliente),
);