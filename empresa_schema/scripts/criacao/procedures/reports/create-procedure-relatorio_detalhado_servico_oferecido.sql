DROP PROCEDURE IF EXISTS relatorio_detalhado_servico_oferecido;

DELIMITER $
CREATE PROCEDURE relatorio_detalhado_servico_oferecido (
    IN dt_hr_inicio DATETIME,
    IN dt_hr_fim DATETIME
)
BEGIN
    SET SESSION sql_mode = 'TRADITIONAL';

    SET @inicio = dt_hr_inicio;
    SET @fim = dt_hr_fim;

    WITH 
        s_cte AS (
            SELECT 
                id_servico_oferecido,
                COUNT(id_servico_oferecido) qtd_serv_periodo,
                AVG(valor_total) media_valor,
                SUM(valor_total) soma_valor
            FROM vw_servico_realizado
            WHERE 
                dt_hr_fim BETWEEN @inicio AND @fim
            GROUP BY 
                id_servico_oferecido
        )
    SELECT 
        s.id_servico_oferecido,
        s.nome,
        s.id_categoria,
        s.nome_categoria,
        s.preco,
        @inicio AS inicio_periodo,
        @fim AS fim_periodo,
        IFNULL(s_c.qtd_serv_periodo, 0) AS qtd_serv_periodo,
        IFNULL(s_c.media_valor, 0) AS media_valor,
        IFNULL(s_c.soma_valor, 0) AS soma_valor
    FROM vw_servico_oferecido s 
        LEFT JOIN s_cte s_c ON (s_c.id_servico_oferecido = s.id_servico_oferecido)
    ORDER BY soma_valor DESC, media_valor DESC, nome ASC, nome_categoria ASC, preco DESC;

END;$$
DELIMITER ;