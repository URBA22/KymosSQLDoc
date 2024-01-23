export enum Keyword{
    ADD = 'ADD',
    ALL = 'ALL',
    ALTER = 'ALTER',
    AND = 'AND',
    ANY = 'ANY',
    AS = 'AS',
    ASC = 'ASC',
    BACKUP = 'BACKUP',
    BEGIN = 'BEGIN',
    BETWEEN = 'BETWEEN',
    CASE = 'CASE',
    CHECK = 'CHECK',
    COLUMN = 'COLUMN',
    CONSTRAINT = 'CONSTRAINT',
    CREATE = 'CREATE',
    DATABASE = 'DATABASE',
    DEFAULT = 'DEFAULT',
    DELETE = 'DELETE',
    DESC = 'DESC',
    DISTINCT = 'DISTINCT',
    DROP = 'DROP',
    END = 'END',
    EXEC = 'EXEC',
    EXISTS = 'EXISTS',
    FOREIGNKEY = 'FOREIGN KEY',
    FROM = 'FROM',
    FULLOUTERJOIN = 'FULL OUTER JOIN',
    GROUPBY = 'GROUP BY',
    HAVING = 'HAVING',
    IN = 'IN',
    INDEX = 'INDEX',
    INNERJOIN = 'INNERJOIN',
    INSERT = 'INSERT',
    INSERTINTO = 'INSERT INTO',
    ISNULL = 'IS NULL',
    ISNOTNULL = 'IS NOT NULL',
    JOIN = 'JOIN',
    LEFTJOIN = 'LEFT JOIN',
    LIKE = 'LIKE',
    LIMIT = 'LIMIT',
    NOT = 'NOT',
    OR = 'OR',
    ORDERBY = 'ORDER BY',
    OUT = 'OUT',
    OUTERJOIN = 'OUTER JOIN',
    OUTPUT = 'OUTPUT',
    PRIMARYKEY = 'PRIMARY KEY',
    PROCEDURE = 'PROCEDURE',
    RIGHTJOIN = 'RIGHT JOIN',
    ROWNUM = 'ROWNUM',
    SELECT = 'SELECT',
    SET = 'SET',
    TABLE = 'TABLE',
    TOP = 'TOP',
    TRUNCATE = 'TRUNCATE',
    UNION = 'UNION',
    UNIQUE = 'UNIQUE',
    UPDATE = 'UPDATE',
    VALUES = 'VALUES',
    VIEW = 'VIEW',
    WHERE = 'WHERE'
}

export class keywordEdit {
    public async hasKeywords(str: string){
        const keywords = Object.keys(Keyword);
        keywords.forEach(keyword =>{
            if(str.indexOf(keyword) != -1) return true;
        });
        return false;
    }
    public async hasKeyword(str: string, keyword: Keyword){
        if(str.indexOf(keyword) != -1) return true;
        return false;
    }

    public async removeKeywords(str: string){
        const keywords = Object.keys(Keyword);
        let res = str;
        keywords.forEach(keyword =>{
            res = res.toUpperCase()
                .replace((' ' + keyword + ' '), ' ') 
                .replace(/[ ]+/g, ' ')
                .trim();
        });
        return res;
    }

    public async removekeyword(str: string, keyword: Keyword){
        return str.toUpperCase().replace((' ' + keyword + ' '), ' ');
    }

}