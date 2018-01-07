/*ALBERTO JESÚS DURÁN LÓPEZ */

%{
#include <stdio.h>
#include <unistd.h>

int valor=-1;
char buffer[500];

/*Sería conveniente usar bool pero no existen en C */
int  metodo=0,
     path=0,
     host=0,
     navegador=0;

void clearScreen(){
   const char *CLEAR_SCREEN_ANSI= "\e[1;1H\e[2J";
   write(STDOUT_FILENO, CLEAR_SCREEN_ANSI, 12);
}

void Comprueba(){
  if(metodo==1 && path==1 && host==1 && navegador==1){
    clearScreen();
    printf("¡Enhorabuena! Los datos introducidos son candidatos a ser una petición HTTP: \n");
    puts(buffer);
    exit(-1);
  }
}



void MeteBuffer(char cadena[20], char yytext[20]){
  strcat(buffer, "\n");
  strcat(buffer, cadena);
  strcat(buffer, yytext);
  strcat(buffer, "\n");
}

%}

/*Regla que lee 0 y muestra la ayuda*/
help 		 [0]$

/*Regla que lee 1 y empieza el programa*/
ok 		   [1]$


/*regla para google*/
google         ^((www".")?(google)(".")?((es)|(com))?)$

/*resto de reglas*/
metodo         "GET"|"POST"|"HEAD"|"PUT"|"DELETE"
cualquier      [a-z]*|[0-9]*|\/|"."|\_
navegador      [mM]"ozilla"|[cC]"hrome"|[sS]"afari"|[oO]"pera"|[fF]"irefox"|[eE]"dge"
path            ^\/({cualquier})*
host            (www\.).+\..+

%%
                 /*----- Sección de Reglas ----------------*/

.           {} /*Si no coincide ninguna no imprimimos nada*/
{help}			{printf("\nActivando la ayuda");valor=0; system("firefox https://github.com/thealberteitor/Modelos-de-Computacion-MC/blob/master/Lex/fichero"); }
{ok}		{clearScreen(); printf("\nPuede empezar a introducir su petición http, que está formada por los campos 'Método, Host, path y Navegador usados'"); valor=1;}

{metodo}  {if(valor==1 && metodo==0){
            printf("Método introducido correctamente \n");
            MeteBuffer("Método: ", yytext);
            metodo=1;
            Comprueba();
          }else if(metodo==1)
            printf("Ya ha introducido el método para la petición HTTP...");
          else
            printf("Debe habilitar la opción de introducir la petición...");
          }


{path} {if(valor==1 && path==0){
              printf("Path introducido correctamente \n");
              MeteBuffer("path: ", yytext);
              path=1;
              Comprueba();
            }else if(path==1)
              printf("Ya ha introducido el path para la petición HTTP...");
            else
              printf("Debe habilitar la opción de introducir la petición...");
            }

{host}     {if(valor==1 && host==0){
            printf("Host introducido correctamente \n");
            MeteBuffer("Host: ", yytext);
            host=1;
            Comprueba();
          }else if(host==1)
            printf("Ya ha introducido la url para la petición HTTP...");
          else
            printf("Debe habilitar la opción de introducir la petición...");
          }

{navegador}  {if(valor==1 && navegador==0){
                printf("Navegador introducido correctamente \n");
                MeteBuffer("Navegador: ", yytext);
                navegador=1;
                Comprueba();
              }else if(navegador==1)
                printf("Ya ha introducido el navegador para la petición HTTP...");
              else
                printf("Debe habilitar la opción de introducir la petición...");
              }

{google}		{printf("\nAbriendo www.google.es "); system("firefox www.google.es");}

%%
                /*----- Sección de Procedimientos --------*/

int main (int argc, char *argv[]){
  valor=-1;
  if (argc == 2){
    yyin = fopen (argv[1], "rt");

    if (yyin == NULL){
      printf ("El fichero %s no se puede abrir\n", argv[1]);
      exit (-1);
    }
  }
  else yyin = stdin;

  clearScreen();
  printf("\n*******************************");
  printf("\nSIMULADOR DE UNA PETICIÓN HTTP\n");

  printf("\nGuía de Ayuda -->  0 \nHabilitar la opción de introducir la solicitud HTTP --> 1 \nUsar Google para obtener información --> www.google.es \n");
  printf("*********************************\n");
  yylex ();

  return 0;
}
