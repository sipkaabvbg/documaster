# documaster
# User's manual
Follow  the  steps :

## 1.Configure  the init.propertirs file 

Configure the init.propertirs, set the full path to the source XML file,full path to the XSD files, 
and the necessary connection settings to the database. 
Currently, the script to create the database and tables does not need to be changed.

## 2. Start the data transfer process

Start the data transfer process by opening a command window and execute the following command.
${ROOT_TOOL_DIR}/java -jar  xml.import-0.0.1-SNAPSHOT.jar ${ROOT_TOOL_DIR}/init.properties
When starting the tool, the database is created by the tool together with the necessary tables. 

## 3.Create Indexes

After successful data transfer, indexes must be created in the database.
The index creation script is in the ${ROOT_TOOL_DIR}/indexes.sql file.
Open the file and run it on the PostgresSQL server's command console or if a graphical tool(pgAdmin) is used in it.


## 4. Validation of the result.

Once the indexes have been successfully created, it is possible to make verification of the correct data transfer.

##Examples with SQL requests for data verification

Find all relevant information for one entry:

select M.mappeid, M.tittel as sub_mappe_tittel,M.offentligtittel as sub_mappe_offentligtittel,
       M.dokumentmedium as sub_mappe_dokumentmedium ,
          (SELECT tittel as super_mappe_tittel from public.mappe where
                                 mappeid = M.sup_mappeid),
          (SELECT offentligtittel  as super_mappe_offentligtittel from public.mappe where 
                                  mappeid = M.sup_mappeid), 
          (SELECT dokumentmedium as super_mappe_dokumentmedium from public.mappe where 
                                  mappeid = M.sup_mappeid),
          B.registreringsid, B.mappeid, registrerings_tittel, dokumenttype, dokumentstatus, dok_tittel, 
          tilknyttetregistreringsom, dokumentnummer,id, versjonsnummer, variantformat, format, 
          referansedokumentfil, sjekksum, sjekksumalgoritme, filstoerrelse, D.registreringsid
     from  public.mappe M,public.basisregistrering B, public.dokumentobjekt D
     where M.sup_mappeid=1
           and M.sup_mappeid is not null
           and M.mappeid=B.mappeid
           and D.registreringsid=B.registreringsid
           and D.registreringsid=1;
           
 Requests to find all sub directories(mappe) of the main one:
 
     WITH RECURSIVE cte AS (
           SELECT mappeid, sup_mappeid, tittel, offentligtittel, dokumentmedium, 1 AS level
           FROM   public.mappe
           WHERE  mappeid = 1
           UNION  ALL
           SELECT t.mappeid, t.sup_mappeid,t.tittel,t.offentligtittel, t.dokumentmedium, c.level + 1
           FROM   cte      c
           JOIN   public.mappe t ON t.sup_mappeid = c.mappeid
           )
                   SELECT mappeid, sup_mappeid, tittel, offentligtittel, dokumentmedium
        FROM   cte
        ORDER  BY level;

Request to find all records in all tables:

       select M.mappeid, M.tittel as sub_mappe_tittel,M.offentligtittel as sub_mappe_offentligtittel,
        M.dokumentmedium as sub_mappe_dokumentmedium ,
          (SELECT tittel as super_mappe_tittel from public.mappe where
                                 mappeid = M.sup_mappeid),
          (SELECT offentligtittel  as super_mappe_offentligtittel from public.mappe where 
                                  mappeid = M.sup_mappeid), 
          (SELECT dokumentmedium as super_mappe_dokumentmedium from public.mappe where 
                                  mappeid = M.sup_mappeid),
          B.registreringsid, B.mappeid, registrerings_tittel, dokumenttype, dokumentstatus, dok_tittel, 
          tilknyttetregistreringsom, dokumentnummer,id, versjonsnummer, variantformat, format, referansedokumentfil, 
          sjekksum, sjekksumalgoritme, filstoerrelse, D.registreringsid
     from  public.mappe M,public.basisregistrering B, public.dokumentobjekt D
     where M.sup_mappeid is not null
           and M.mappeid=B.mappeid
           and D.registreringsid=B.registreringsid;

