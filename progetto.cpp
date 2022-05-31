#include<cstdio>
# include<iostream>
# include<fstream>
# include"dependencies/include/libpq-fe.h" 

# define PG_HOST    "127.0.0.1"
# define PG_USER    "postgres" 
# define PG_DB      "progetto" // nome del db
# define PG_PASS    "password" // password utilizzata per l' accesso in pgadmin
# define PG_PORT    5432

using namespace std;

void checkResults( PGresult * res , const PGconn * conn ) {
    if ( PQresultStatus(res) != PGRES_TUPLES_OK ) {
        cout << "Risultati inconsistenti!" << PQerrorMessage(conn) << endl ;
        PQclear(res) ;
        exit (1);
    }
}

int main(int argc, char **argv){
    
    char conninfo[250];
    
    sprintf (conninfo,"user=%s password=%s dbname=%s hostaddr=%s port=%d ",PG_USER,PG_PASS,PG_DB,PG_HOST,PG_PORT) ;

    PGconn * conn=PQconnectdb(conninfo);
// controllo connessione
   if ( PQstatus(conn) != CONNECTION_OK ) {
        cout << " Errore di connessione " << PQerrorMessage(conn) ;
        PQfinish(conn);
        exit(1);
    }
    else {
        cout << "Connessione avvenuta correttamente"<< endl;
        //PQfinish(conn);
    }

    PGresult * res ;
    res = PQexec ( conn , " SELECT * FROM dipendente " ) ;

    checkResults(res, conn);

    int tuple = PQntuples( res );
    int campi = PQnfields( res );

// Stampo intestazioni
    for ( int i = 0; i < campi ; ++ i ) {
        cout << PQfname( res , i ) << " \t\t ";
    }
    cout << endl;

// Stampo i valori selezionati
    for ( int i = 0; i < tuple ; ++ i ) {
        for ( int j = 0; j < campi ; ++ j ) {
            cout << PQgetvalue( res , i , j) << "\t\t" ;
        }
    cout << endl;
    }

    PQclear(res);
    PQfinish(conn);
    
    return 0;
}