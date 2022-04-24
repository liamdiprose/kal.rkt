#lang brag
expr: term (OPERATOR term)* | boolean (LOGIC-OPERATOR boolean)*
term: factor (/'*' factor)*
factor: NUMBER
NUMBER: DIGIT+
DIGIT: "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
boolean: TRUE | FALSE
FALSE: "false" | "0"
TRUE: "true" | "1"
OPERATOR: LOGIC_OPERATOR | "+" | "-"

LOGIC-OPERATOR: AND | XOR | OR
AND: "and" | "&&"
XOR: "xor" | "^"
OR: "or" | "||"
BOOLEAN: "true" | "false"
