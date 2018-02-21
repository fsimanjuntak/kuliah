@REM nilmsmappee-core launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM NILMSMAPPEE_CORE_config.txt found in the NILMSMAPPEE_CORE_HOME.
@setlocal enabledelayedexpansion

@echo off

if "%NILMSMAPPEE_CORE_HOME%"=="" set "NILMSMAPPEE_CORE_HOME=%~dp0\\.."

set "APP_LIB_DIR=%NILMSMAPPEE_CORE_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%NILMSMAPPEE_CORE_HOME%\NILMSMAPPEE_CORE_config.txt"
set CFG_OPTS=
if exist "%CFG_FILE%" (
  FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%CFG_FILE%") DO (
    set DO_NOT_REUSE_ME=%%i
    rem ZOMG (Part #2) WE use !! here to delay the expansion of
    rem CFG_OPTS, otherwise it remains "" for this loop.
    set CFG_OPTS=!CFG_OPTS! !DO_NOT_REUSE_ME!
  )
)

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running nilmsmappee-core.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=

:param_loop
call set _PARAM1=%%1
set "_TEST_PARAM=%~1"

if ["!_PARAM1!"]==[""] goto param_afterloop


rem ignore arguments that do not start with '-'
if "%_TEST_PARAM:~0,1%"=="-" goto param_java_check
set _APP_ARGS=!_APP_ARGS! !_PARAM1!
shift
goto param_loop

:param_java_check
if "!_TEST_PARAM:~0,2!"=="-J" (
  rem strip -J prefix
  set _JAVA_PARAMS=!_JAVA_PARAMS! !_TEST_PARAM:~2!
  shift
  goto param_loop
)

if "!_TEST_PARAM:~0,2!"=="-D" (
  rem test if this was double-quoted property "-Dprop=42"
  for /F "delims== tokens=1,*" %%G in ("!_TEST_PARAM!") DO (
    if not ["%%H"] == [""] (
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
    ) else if [%2] neq [] (
      rem it was a normal property: -Dprop=42 or -Drop="42"
      call set _PARAM1=%%1=%%2
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      shift
    )
  )
) else (
  if "!_TEST_PARAM!"=="-main" (
    call set CUSTOM_MAIN_CLASS=%%2
    shift
  ) else (
    set _APP_ARGS=!_APP_ARGS! !_PARAM1!
  )
)
shift
goto param_loop
:param_afterloop

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!
:run
 
set "APP_CLASSPATH=%APP_LIB_DIR%\rugds.nilmsmappee-core-0.1-SNAPSHOT.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.11.8.jar;%APP_LIB_DIR%\org.joda.joda-convert-1.8.1.jar;%APP_LIB_DIR%\rugds.service-core_2.11-0.18.2.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-1.7.25.jar;%APP_LIB_DIR%\joda-time.joda-time-2.9.9.jar;%APP_LIB_DIR%\com.typesafe.config-1.3.1.jar;%APP_LIB_DIR%\org.clapper.grizzled-slf4j_2.11-1.3.0.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-actor_2.11-2.4.17.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-slf4j_2.11-2.4.17.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-stream_2.11-2.4.17.jar;%APP_LIB_DIR%\org.reactivestreams.reactive-streams-1.0.0.jar;%APP_LIB_DIR%\com.typesafe.ssl-config-core_2.11-0.2.1.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-parser-combinators_2.11-1.0.4.jar;%APP_LIB_DIR%\rugds.service-predef_2.11-0.18.2.jar;%APP_LIB_DIR%\rugds.consul_2.11-0.18.2.jar;%APP_LIB_DIR%\rugds.rest_2.11-0.18.2.jar;%APP_LIB_DIR%\io.spray.spray-json_2.11-1.3.3.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-http_2.11-10.0.5.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-http-core_2.11-10.0.5.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-parsing_2.11-10.0.5.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-http-spray-json_2.11-10.0.5.jar;%APP_LIB_DIR%\rugds.graphdb_2.11-0.18.2.jar;%APP_LIB_DIR%\com.orientechnologies.orientdb-core-2.2.12.jar;%APP_LIB_DIR%\com.googlecode.concurrentlinkedhashmap.concurrentlinkedhashmap-lru-1.4.1.jar;%APP_LIB_DIR%\com.orientechnologies.orientdb-client-2.2.12.jar;%APP_LIB_DIR%\com.orientechnologies.orientdb-graphdb-2.2.12.jar;%APP_LIB_DIR%\com.orientechnologies.orientdb-server-2.2.12.jar;%APP_LIB_DIR%\com.orientechnologies.orientdb-tools-2.2.12.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-databind-2.6.0.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-annotations-2.6.0.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-core-2.6.0.jar;%APP_LIB_DIR%\javax.mail.mail-1.4.7.jar;%APP_LIB_DIR%\javax.activation.activation-1.1.jar;%APP_LIB_DIR%\commons-collections.commons-collections-3.2.2.jar;%APP_LIB_DIR%\com.tinkerpop.blueprints.blueprints-core-2.6.0.jar;%APP_LIB_DIR%\org.codehaus.jettison.jettison-1.3.3.jar;%APP_LIB_DIR%\stax.stax-api-1.0.1.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.1.1.jar;%APP_LIB_DIR%\com.orientechnologies.orientdb-object-2.2.12.jar;%APP_LIB_DIR%\org.hibernate.javax.persistence.hibernate-jpa-2.0-api-1.0.0.Final.jar;%APP_LIB_DIR%\org.javassist.javassist-3.16.1-GA.jar;%APP_LIB_DIR%\com.michaelpollmeier.gremlin-scala_2.11-3.2.3.2.jar;%APP_LIB_DIR%\com.michaelpollmeier.macros_2.11-3.2.3.2.jar;%APP_LIB_DIR%\org.apache.tinkerpop.gremlin-core-3.2.3.jar;%APP_LIB_DIR%\org.apache.tinkerpop.gremlin-shaded-3.2.3.jar;%APP_LIB_DIR%\commons-configuration.commons-configuration-1.10.jar;%APP_LIB_DIR%\commons-lang.commons-lang-2.6.jar;%APP_LIB_DIR%\org.yaml.snakeyaml-1.15.jar;%APP_LIB_DIR%\org.javatuples.javatuples-1.2.jar;%APP_LIB_DIR%\com.carrotsearch.hppc-0.7.1.jar;%APP_LIB_DIR%\com.jcabi.jcabi-manifests-1.1.jar;%APP_LIB_DIR%\com.jcabi.jcabi-log-0.14.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.11.8.jar;%APP_LIB_DIR%\com.chuusai.shapeless_2.11-2.3.2.jar;%APP_LIB_DIR%\org.typelevel.macro-compat_2.11-1.1.1.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-xml_2.11-1.0.5.jar;%APP_LIB_DIR%\com.michaelpollmeier.orientdb-gremlin-3.2.3.0.jar;%APP_LIB_DIR%\org.apache.tinkerpop.gremlin-groovy-3.2.3.jar;%APP_LIB_DIR%\org.apache.ivy.ivy-2.3.0.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-2.4.7-indy.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-groovysh-2.4.7-indy.jar;%APP_LIB_DIR%\jline.jline-2.12.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-console-2.4.7.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-swing-2.4.7.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-templates-2.4.7.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-xml-2.4.7.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-json-2.4.7-indy.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-jsr223-2.4.7-indy.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.3.1.jar;%APP_LIB_DIR%\com.github.t3hnar.scala-bcrypt_2.11-3.0.jar;%APP_LIB_DIR%\de.svenkubiak.jBCrypt-0.4.1.jar;%APP_LIB_DIR%\rugds.timeseries-core_2.11-0.18.2.jar;%APP_LIB_DIR%\rugds.cassandra_2.11-0.18.2.jar;%APP_LIB_DIR%\com.datastax.cassandra.cassandra-driver-core-3.2.0.jar;%APP_LIB_DIR%\io.netty.netty-handler-4.0.44.Final.jar;%APP_LIB_DIR%\io.netty.netty-buffer-4.0.44.Final.jar;%APP_LIB_DIR%\io.netty.netty-common-4.0.44.Final.jar;%APP_LIB_DIR%\io.netty.netty-transport-4.0.44.Final.jar;%APP_LIB_DIR%\io.netty.netty-codec-4.0.44.Final.jar;%APP_LIB_DIR%\com.google.guava.guava-19.0.jar;%APP_LIB_DIR%\io.dropwizard.metrics.metrics-core-3.1.2.jar;%APP_LIB_DIR%\com.github.jnr.jnr-ffi-2.0.7.jar;%APP_LIB_DIR%\com.github.jnr.jffi-1.2.10.jar;%APP_LIB_DIR%\com.github.jnr.jffi-1.2.10-native.jar;%APP_LIB_DIR%\org.ow2.asm.asm-5.0.3.jar;%APP_LIB_DIR%\org.ow2.asm.asm-commons-5.0.3.jar;%APP_LIB_DIR%\org.ow2.asm.asm-tree-5.0.3.jar;%APP_LIB_DIR%\org.ow2.asm.asm-analysis-5.0.3.jar;%APP_LIB_DIR%\org.ow2.asm.asm-util-5.0.3.jar;%APP_LIB_DIR%\com.github.jnr.jnr-x86asm-1.0.2.jar;%APP_LIB_DIR%\com.github.jnr.jnr-posix-3.0.27.jar;%APP_LIB_DIR%\com.github.jnr.jnr-constants-0.9.0.jar;%APP_LIB_DIR%\rugds.amqp_2.11-0.18.2.jar;%APP_LIB_DIR%\com.rabbitmq.amqp-client-4.1.0.jar;%APP_LIB_DIR%\rugds.kafka_2.11-0.18.2.jar;%APP_LIB_DIR%\ch.qos.logback.logback-classic-1.2.3.jar;%APP_LIB_DIR%\ch.qos.logback.logback-core-1.2.3.jar;%APP_LIB_DIR%\org.slf4j.jcl-over-slf4j-1.7.25.jar;%APP_LIB_DIR%\org.slf4j.log4j-over-slf4j-1.7.25.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-stream-kafka_2.11-0.15.jar;%APP_LIB_DIR%\org.apache.kafka.kafka-clients-0.10.2.0.jar;%APP_LIB_DIR%\net.jpountz.lz4.lz4-1.3.0.jar;%APP_LIB_DIR%\org.xerial.snappy.snappy-java-1.1.2.6.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.10.jar;%APP_LIB_DIR%\com.github.blemale.scaffeine_2.11-2.0.0.jar;%APP_LIB_DIR%\com.github.ben-manes.caffeine.caffeine-2.3.5.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-java8-compat_2.11-0.8.0.jar;%APP_LIB_DIR%\com.google.code.findbugs.jsr305-3.0.2.jar"
set "APP_MAIN_CLASS=rugds.nilm.app.NilmsmappeecoreMain"

if defined CUSTOM_MAIN_CLASS (
    set MAIN_CLASS=!CUSTOM_MAIN_CLASS!
) else (
    set MAIN_CLASS=!APP_MAIN_CLASS!
)

rem Call the application and pass all arguments unchanged.
"%_JAVACMD%" !_JAVA_OPTS! !NILMSMAPPEE_CORE_OPTS! -cp "%APP_CLASSPATH%" %MAIN_CLASS% !_APP_ARGS!

@endlocal


:end

exit /B %ERRORLEVEL%
