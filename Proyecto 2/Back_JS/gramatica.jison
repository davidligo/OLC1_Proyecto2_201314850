/**
 * Ejemplo Intérprete Sencillo con Jison utilizando Nodejs en Ubuntu
 */

 %{
	const errores_lexicos		= [];
	const errores_sintacticos 	= [];
	function ast(padre, hijos){
         this.padre = padre;
         this.hijos = hijos;
    }
	function crearErrorL(descripcion, fila, columna){
  		this.descripcion = descripcion;
  		this.fila = fila;
  		this.columna = columna;
	}
%}

/* Definición Léxica */
%lex

%options case-sensitive

%%

\s+											// se ignoran espacios en blanco
"//".*										// comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]			// comentario multiple líneas

"public"			return 'RPUBLIC';
"class"				{ console.log("buenas"); return 'RCLASS';}
"interface"			return 'RINTERFACE';
"void"				return 'RVOID';
"for"				return 'RFOR';
"while"				return 'RWHILE';
"System"			return 'RSYSTEM';
"out"				return 'ROUT';
"println"			return 'RPRINTLN';
"do"				return 'RDO';
"true"				return 'RTRUE';
"false"				return 'RFALSE';
"if"				return 'RIF';
"else"				return 'RELSE';
"break"				return 'RBREAK';
"continue"			return 'RCONTINUE';
"return"			return 'RRETURN';
"int"				return 'RINT';
"boolean"			return 'RBOOLEAN';
"double"			return 'RDOUBLE';
"String"			return 'RSTRING';
"char"				return 'RCHAR';
"static"			return 'RSTATIC';
"print"				return 'RPRINT';


","					return 'COMA';
"."					return 'PUNTO';
";"					return 'PTCOMA';
"{"					return 'LLAVIZQ';
"}"					return 'LLAVDER';
"("					return 'PARIZQ';
")"					return 'PARDER';
"["					return 'CORIZQ';
"]"					return 'CORDER';


"&&"				return 'AND'
"||"				return 'OR';

"+"					return 'MAS';
"-"					return 'MENOS';
"*"					return 'POR';
"/"					return 'DIVIDIDO';

"++"				return 'MASMAS';
"--"				return 'MENOSMENOS';

"<="				return 'MENIGQUE';
">="				return 'MAYIGQUE';
"=="				return 'DOBLEIG';
"!="				return 'NOIG';

"<"					return 'MENQUE';
">"					return 'MAYQUE';
"="					return 'IGUAL';

"!"					return 'NOT';
"^"					return 'XOR';

\"[^\"]*\"				{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
\'[^\']\'				{ yytext = yytext.substr(1,yyleng-2); return 'CARACTER'; }
[0-9]+("."[0-9]+)?\b  	return 'DECIMAL';
[0-9]+\b				return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*	return 'IDENTIFICADOR';


<<EOF>>				return 'EOF';
.					{ console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);
						errores_lexicos.push(new crearErrorL("La cadena "+ yytext + " no pertenece al lenguaje.", yylloc.first_line, yylloc.first_column));
					}

/lex





/* Asociación de operadores y precedencia */
%left 'MAS' 'MENOS'
%left 'POR' 'DIVIDIDO'
%left UMENOS
%left UNEGADO

%start ini

%% /* Definición de la gramática */

ini
	: lista_clases  EOF 
    { 
        var raiz = new ast("ini",$1); 
        console.log(JSON.stringify(raiz));
    }
;

lista_clases
    : lista_clases clase_interfaz { let arreglo5 = []; arreglo5.push($1); arreglo5.push($2)   ; $$ = new ast("lista_clases",arreglo5);  ;}
    | clase_interfaz { $$ = new ast("lista_clases",$1); }
    | error PTCOMA { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

clase_interfaz
    : RPUBLIC tipo_clase IDENTIFICADOR LLAVIZQ lista_instrucciones_clase LLAVDER { let arreglo4 = []; arreglo4.push($1); arreglo4.push($2); arreglo4.push($3); arreglo4.push($4); arreglo4.push($5); arreglo4.push($6); $$ = new ast("clase",arreglo4);  }
;


tipo_clase 
    : RCLASS  { $$ = new ast("tipo_clase",$1);  }
    | RINTERFACE { $$ = new ast("tipo_clase",$1);  }
;


lista_instrucciones_clase
    : lista_instrucciones_clase instrucciones_clase { let arreglolista_instruccionesclase = []; arreglolista_instruccionesclase.push($1); arreglolista_instruccionesclase.push($2); $$ = new ast("lista_instrucciones_clase", arreglolista_instruccionesclase); }
    | instrucciones_clase { $$ = new ast("lista_instrucciones_clase",$1);  }
    
;

instrucciones_clase
    : declaracion PTCOMA { let arregloinstrucciones_clase = []; arregloinstrucciones_clase.push($1); arregloinstrucciones_clase.push($2); $$ = new ast("instrucciones_clase", arregloinstrucciones_clase); }
    | metodo_funcion { $$ = new ast("instrucciones_clase",$1);  }
    | error PTCOMA { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

metodo_funcion
    : RPUBLIC tipo_funcion IDENTIFICADOR PARIZQ lista_parametros PARDER LLAVIZQ lista_instrucciones LLAVDER { arreglometodo_funcion= []; arreglometodo_funcion.push($1); arreglometodo_funcion.push($2); arreglometodo_funcion.push($3); arreglometodo_funcion.push($4); arreglometodo_funcion.push($5); arreglometodo_funcion.push($6); arreglometodo_funcion.push($7); arreglometodo_funcion.push($8); arreglometodo_funcion.push($9); $$ = new ast("metodo_funcion", arreglometodo_funcion); }
    
; 

lista_instrucciones
    : lista_instrucciones instrucciones { let arreglolista_instrucciones = []; arreglolista_instrucciones.push($1); arreglolista_instrucciones.push($2); $$ = new ast("lista_instrucciones", arreglolista_instrucciones); }
    | instrucciones                     { $$ = new ast("lista_instrucciones",$1); }
;

instrucciones
    : asignacion_for PTCOMA { let arregloinstrucciones1 = []; arregloinstrucciones1.push($1); arregloinstrucciones1.push($2); $$ = new ast("instrucciones", arregloinstrucciones1); }
    | imprimir PTCOMA { let arregloinstrucciones2 = []; arregloinstrucciones2.push($1); arregloinstrucciones2.push($2); $$ = new ast("instrucciones", arregloinstrucciones2); }
    | sentencia_if { $$ = new ast("instrucciones",$1); }
    | sentencia_for { $$ = new ast("instrucciones",$1); }
    | sentencia_while { $$ = new ast("instrucciones",$1); }
    | sentencia_do { $$ = new ast("instrucciones",$1); }
    | sentencia_return { $$ = new ast("instrucciones",$1); }
;

sentencia_return
    : RRETURN expresion PTCOMA { let arreglosentencia_return = []; arreglosentencia_return.push($1); arreglosentencia_return.push($2); arreglosentencia_return.push($3); $$ = new ast("sentencia_return", arreglosentencia_return); }
;

sentencia_do
    : RDO bloque RWHILE PARIZQ expresion_logica PARDER PTCOMA  { let arreglosentencia_do = []; arreglosentencia_do.push($1); arreglosentencia_do.push($2); arreglosentencia_do.push($3); arreglosentencia_do.push($4); arreglosentencia_do.push($5); arreglosentencia_do.push($6); arreglosentencia_do.push($7); $$ = new ast("sentencia_do", arreglosentencia_do); }
;

sentencia_while
    : RWHILE PARIZQ expresion_logica PARDER bloque { let arreglosentencia_while = []; arreglosentencia_while.push($1); arreglosentencia_while.push($2); arreglosentencia_while.push($3); arreglosentencia_while.push($4); arreglosentencia_while.push($5); $$ = new ast("sentencia_while", arreglosentencia_while); }
;

sentencia_for
    : RFOR PARIZQ asignacion_for PTCOMA expresion_logica PTCOMA asignacion  PARDER bloque { let arreglosentencia_for = []; arreglosentencia_for.push($1); arreglosentencia_for.push($2); arreglosentencia_for.push($3); arreglosentencia_for.push($4); arreglosentencia_for.push($5); arreglosentencia_for.push($6); arreglosentencia_for.push($7); arreglosentencia_for.push($8); arreglosentencia_for.push($9); $$ = new ast("sentencia_for", arreglosentencia_for); }
;

sentencia_if
    : lista_condicionesIf RELSE  bloque { let arreglosentencia_if1 = []; arreglosentencia_if1.push($1); arreglosentencia_if1.push($2); arreglosentencia_if1.push($3); $$ = new ast("sentencia_if", arreglosentencia_if1);}
    | lista_condicionesIf    { $$ = new ast("sentencia_if",$1); }
;

lista_condicionesIf
    : lista_condicionesIf RELSE RIF PARIZQ expresion_logica PARDER bloque { let arreglolista_condicionesIf1 = []; arreglolista_condicionesIf1.push($1); arreglolista_condicionesIf1.push($2); arreglolista_condicionesIf1.push($3); arreglolista_condicionesIf1.push($4); arreglolista_condicionesIf1.push($5); arreglolista_condicionesIf1.push($6); arreglolista_condicionesIf1.push($7); $$ = new ast("lista_condicionesIf", arreglolista_condicionesIf1);}
    | RIF PARIZQ expresion_logica PARDER bloque { let arreglolista_condicionesIf2 = []; arreglolista_condicionesIf2.push($1); arreglolista_condicionesIf2.push($2); arreglolista_condicionesIf2.push($3); arreglolista_condicionesIf2.push($4); arreglolista_condicionesIf2.push($5); $$ = new ast("lista_condicionesIf", arreglolista_condicionesIf2);}
;

bloque
    : LLAVIZQ LLAVDER { let arreglobloque1 = []; arreglobloque1.push($1); arreglobloque1.push($2);  $$ = new ast("bloque", arreglobloque1);}
    | LLAVIZQ lista_instrucciones LLAVDER { let arreglobloque2 = []; arreglobloque2.push($1); arreglobloque2.push($2); arreglobloque2.push($3); $$ = new ast("bloque", arreglobloque2);}
;

imprimir
    : RSYSTEM PUNTO ROUT PUNTO tipo_imprimir PARIZQ expresion PARDER { let arregloimprimir = []; arregloimprimir.push($1); arregloimprimir.push($2); arregloimprimir.push($3); arregloimprimir.push($4); arregloimprimir.push($5); arregloimprimir.push($6); arregloimprimir.push($7); arregloimprimir.push($8); $$ = new ast("imprimir", arregloimprimir); }
;

tipo_imprimir
    : RPRINTLN { $$ = new ast("tipo_imprimir",$1); }
    | RPRINT { $$ = new ast("tipo_imprimir",$1); }
;

asignacion_for
    : asignacion    { $$ = new ast("asignacion_for",$1); }
    | declaracion   { $$ = new ast("asignacion_for",$1); }
;

asignacion
    : IDENTIFICADOR IGUAL expresion    { let arregloasignacion1 = []; arregloasignacion1.push($1); arregloasignacion1.push($2); arregloasignacion1.push($3); $$ = new ast("asignacion", arregloasignacion1);  }
    | IDENTIFICADOR MASMAS                      { let arregloasignacion2 = []; arregloasignacion2.push($1); arregloasignacion2.push($2); $$ = new ast("asignacion", arregloasignacion2);  }
    | IDENTIFICADOR MENOSMENOS                  { let arregloasignacion3 = []; arregloasignacion3.push($1); arregloasignacion3.push($2); $$ = new ast("asignacion", arregloasignacion3);  }
;

lista_parametros
    : lista_parametros COMA parametro   { let arreglolista_parametros = []; arreglolista_parametros.push($1); arreglolista_parametros.push($2); arreglolista_parametros.push($3);  $$ = new ast("lista_parametros", arreglolista_parametros); }
    | parametro                         { $$ = new ast("lista_parametros",$1); }
    |
;

parametro
    : tipo_variable IDENTIFICADOR { let arregloparametro = []; arregloparametro.push($1); arregloparametro.push($2); $$ = new ast("parametro", arregloparametro); }
;


tipo_funcion
    : RVOID             { $$ = new ast("tipo_funcion",$1); }
    | tipo_variable     { $$ = new ast("tipo_funcion",$1); }
;

declaracion
    : tipo_variable lista_declaraciones { let arreglodeclaracion = []; arreglodeclaracion.push($1); arreglodeclaracion.push($2); $$ = new ast("declaracion", arreglodeclaracion); }
    
;

tipo_variable
    : RINT      { $$ = new ast("tipo_variable",$1); }
    | RBOOLEAN  { $$ = new ast("tipo_variable",$1); }
    | RDOUBLE   { $$ = new ast("tipo_variable",$1); }
    | RSTRING   { $$ = new ast("tipo_variable",$1); }
    | RCHAR     { $$ = new ast("tipo_variable",$1); }
;

lista_declaraciones
    : lista_declaraciones COMA declaraciones { let arreglolista_declaraciones = []; arreglolista_declaraciones.push($1); arreglolista_declaraciones.push($2); arreglolista_declaraciones.push($3); $$ = new ast("lista_declaraciones", arreglolista_declaraciones); }
    | declaraciones { $$ = new ast("lista_declaraciones",$1); }
;

declaraciones
    : IDENTIFICADOR IGUAL expresion    { let arreglodeclaraciones = []; arreglodeclaraciones.push($1); arreglodeclaraciones.push($2); arreglodeclaraciones.push($3); $$ = new ast("declaraciones", arreglodeclaraciones); }
    | IDENTIFICADOR                    { $$ = new ast("declaraciones",$1); }
    | error PTCOMA { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }

;

expresion
    : expresion_numerica    { $$ = new ast("expresion",$1); }
    | expresion_logica      { $$ = new ast("expresion",$1); }
    | error PTCOMA { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

expresion_numerica
	: MENOS expresion_numerica %prec UMENOS				{ let arregloexpresion_numerica1 = []; arregloexpresion_numerica1.push($1); arregloexpresion_numerica1.push($2); $$ = new ast("expresion_numerica", arregloexpresion_numerica1);  }
	| PARIZQ expresion_numerica PARDER					{ let arregloexpresion_numerica2 = []; arregloexpresion_numerica2.push($1); arregloexpresion_numerica2.push($2); arregloexpresion_numerica2.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica2);  }
	| ENTERO											{ $$ = new ast("expresion_numerica",$1); }
	| DECIMAL											{ $$ = new ast("expresion_numerica",$1); }
	| expresion_numerica MAS expresion_numerica			{ let arregloexpresion_numerica3 = []; arregloexpresion_numerica3.push($1); arregloexpresion_numerica3.push($2); arregloexpresion_numerica3.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica3);}
	| expresion_numerica MENOS expresion_numerica		{ let arregloexpresion_numerica4 = []; arregloexpresion_numerica4.push($1); arregloexpresion_numerica4.push($2); arregloexpresion_numerica4.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica4);}
	| expresion_numerica POR expresion_numerica			{ let arregloexpresion_numerica5 = []; arregloexpresion_numerica5.push($1); arregloexpresion_numerica5.push($2); arregloexpresion_numerica5.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica5);}
	| expresion_numerica DIVIDIDO expresion_numerica	{ let arregloexpresion_numerica6 = []; arregloexpresion_numerica6.push($1); arregloexpresion_numerica6.push($2); arregloexpresion_numerica6.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica6);}
	| IDENTIFICADOR										{ $$ = new ast("expresion_numerica",$1); }
    | CADENA										    { $$ = new ast("expresion_numerica",$1); }
    | CARACTER										    { $$ = new ast("expresion_numerica",$1); }
    | IDENTIFICADOR MASMAS	                            { let arregloexpresion_numerica13 = []; arregloexpresion_numerica13.push($1); arregloexpresion_numerica13.push($2);  $$ = new ast("expresion_numerica", arregloexpresion_numerica13);}
    | IDENTIFICADOR MENOSMENOS	                        { let arregloexpresion_numerica14 = []; arregloexpresion_numerica14.push($1); arregloexpresion_numerica14.push($2);  $$ = new ast("expresion_numerica", arregloexpresion_numerica14);}
;


expresion_relacional
	: expresion_numerica MENQUE expresion_numerica	    { let arregloexpresion_numerica8 = []; arregloexpresion_numerica8.push($1); arregloexpresion_numerica8.push($2); arregloexpresion_numerica8.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica8);}
    | expresion_numerica MAYQUE expresion_numerica	    { let arregloexpresion_numerica9 = []; arregloexpresion_numerica9.push($1); arregloexpresion_numerica9.push($2); arregloexpresion_numerica9.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica9);}
	| expresion_numerica MENIGQUE expresion_numerica	{ let arregloexpresion_numerica10 = []; arregloexpresion_numerica10.push($1); arregloexpresion_numerica10.push($2); arregloexpresion_numerica10.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica10);}
    | expresion_numerica MAYIGQUE expresion_numerica	{ let arregloexpresion_numerica11 = []; arregloexpresion_numerica11.push($1); arregloexpresion_numerica11.push($2); arregloexpresion_numerica11.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica11);}
    | expresion_numerica DOBLEIG expresion_numerica	    { let arregloexpresion_numerica7 = []; arregloexpresion_numerica7.push($1); arregloexpresion_numerica7.push($2); arregloexpresion_numerica7.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica7);}
    | expresion_numerica NOIG expresion_numerica	    { let arregloexpresion_numerica12 = []; arregloexpresion_numerica12.push($1); arregloexpresion_numerica12.push($2); arregloexpresion_numerica12.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica12);}
    | RTRUE										        { $$ = new ast("expresion_relacional",$1); }
    | RFALSE										    { $$ = new ast("expresion_relacional",$1); }
;


expresion_logica
	: NOT expresion_logica	 %prec UNEGADO			{ let arregloexpresion_logica4 = []; arregloexpresion_logica4.push($1); arregloexpresion_logica4.push($2); $$ = new ast("expresion_logica", arregloexpresion_logica4);}
    | PARIZQ expresion_logica PARDER				{ let arregloexpresion_logica5 = []; arregloexpresion_logica5.push($1); arregloexpresion_logica5.push($2); arregloexpresion_logica5.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica5);}
	| expresion_relacional AND expresion_logica     { let arregloexpresion_logica1 = []; arregloexpresion_logica1.push($1); arregloexpresion_logica1.push($2); arregloexpresion_logica1.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica1);}
	| expresion_relacional OR expresion_logica 		{ let arregloexpresion_logica2 = []; arregloexpresion_logica2.push($1); arregloexpresion_logica2.push($2); arregloexpresion_logica2.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica2);}
    | expresion_relacional XOR expresion_logica 	{ let arregloexpresion_logica3 = []; arregloexpresion_logica3.push($1); arregloexpresion_logica3.push($2); arregloexpresion_logica3.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica3);}
	| expresion_relacional								{ $$ = new ast("expresion_logica",$1); }
    
;
