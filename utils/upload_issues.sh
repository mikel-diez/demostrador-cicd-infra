#!/bin/bash

# Colores para una mejor visualización
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar si GitHub CLI está instalado
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) no está instalado.${NC}"
    exit 1
fi

# Configuración con valores correctos
REPO="mikel-diez/demostradorcicd"
PROJECT_URL="https://github.com/users/mikel-diez/projects/1"

echo -e "${BLUE}Configurando etiquetas en el repositorio ${REPO}...${NC}"

# Lista de etiquetas por columna
BACKLOG_LABELS="backlog"
READY_LABELS="ready"
IN_PROGRESS_LABELS="in-progress"
IN_REVIEW_LABELS="in-review"
DONE_LABELS="done"

# Crear etiquetas básicas para las columnas
gh label create "$BACKLOG_LABELS" --repo "$REPO" --color "c5def5" --force >/dev/null 2>&1
gh label create "$READY_LABELS" --repo "$REPO" --color "bfdadc" --force >/dev/null 2>&1
gh label create "$IN_PROGRESS_LABELS" --repo "$REPO" --color "bfd4f2" --force >/dev/null 2>&1
gh label create "$IN_REVIEW_LABELS" --repo "$REPO" --color "d4c5f9" --force >/dev/null 2>&1
gh label create "$DONE_LABELS" --repo "$REPO" --color "0e8a16" --force >/dev/null 2>&1

# Función para crear una issue con etiqueta de columna
create_issue() {
    TITLE="$1"
    BODY="$2"
    LABELS="$3"
    COLUMN="$4"
    
    echo -e "${BLUE}Creando issue: ${YELLOW}$TITLE${NC}"
    
    # Añadir información de la columna al cuerpo de la issue
    FULL_BODY="$BODY\n\n---\n\n**Columna en tablero Kanban:** $COLUMN"
    
    # Crear la issue
    ISSUE_URL=$(gh issue create --repo "$REPO" --title "$TITLE" --body "$FULL_BODY" --label "$LABELS")
    
    if [ -z "$ISSUE_URL" ]; then
        echo -e "${RED}Error al crear la issue.${NC}"
        return
    fi
    
    echo -e "${GREEN}Issue creada: $ISSUE_URL${NC}"
    echo -e "${YELLOW}Columna para asignar manualmente: $COLUMN${NC}"
    
    # Pequeña pausa
    sleep 1
}

# CREAR ISSUES PARA CADA COLUMNA

echo -e "\n${BLUE}========== CREANDO ISSUES PARA BACKLOG ==========${NC}"

create_issue "[DIS-02] Diseñar estructura de almacenamiento e indexación de datos" \
"Crear un modelo detallado para la estructura de datos que optimice el almacenamiento y recuperación de información heterogénea. Incluir esquemas de particionamiento, estrategias de indexación y diseño de colecciones/tablas. Debe considerar la naturaleza distribuida del sistema y los patrones de consulta previstos." \
"diseño,almacenamiento,$BACKLOG_LABELS" "Backlog"

create_issue "[SCR-02] Crear orquestador de tareas de extracción" \
"Implementar un sistema que gestione la programación, ejecución y monitorización de tareas de extracción para diferentes fuentes. Debe proporcionar capacidades para definir frecuencias de actualización personalizadas por fuente, priorizar extracciones según la importancia de los datos, y manejar reintentos en caso de fallos temporales." \
"extracción,orquestación,$BACKLOG_LABELS" "Backlog"

create_issue "[CHAT-02] Crear generador de respuestas contextualizadas" \
"Implementar un sistema que, a partir de los resultados de búsqueda en la base de datos, genere respuestas coherentes y contextualizadas. El componente debe combinar información de múltiples fuentes, mantener coherencia narrativa, proporcionar referencias a las fuentes originales y adaptar el nivel de detalle según la consulta." \
"chatbot,lenguaje-natural,$BACKLOG_LABELS" "Backlog"

create_issue "[BUG-02] Respuestas incoherentes en consultas complejas" \
"Cuando las consultas involucran comparaciones temporales complejas (ej: \"comparar tendencias del último trimestre con el mismo periodo del año anterior\"), el sistema ocasionalmente produce respuestas con inconsistencias lógicas. Reproducible en aproximadamente 15% de las consultas complejas. Prioridad: Media." \
"bug,chatbot,prioridad-media,$BACKLOG_LABELS" "Backlog"

echo -e "\n${BLUE}========== CREANDO ISSUES PARA READY ==========${NC}"

create_issue "[DIS-01] Definir arquitectura general del sistema" \
"Desarrollar un documento de arquitectura que especifique los componentes principales del sistema, sus relaciones y responsabilidades. Debe incluir diagramas de alto nivel que muestren el flujo de datos desde la extracción hasta la presentación al usuario, así como justificaciones para las decisiones arquitectónicas principales." \
"diseño,arquitectura,$READY_LABELS" "Ready"

create_issue "[API-01] Diseñar e implementar API RESTful completa" \
"Desarrollar una API bien documentada que exponga las funcionalidades del sistema a aplicaciones externas. Incluir endpoints para búsqueda, consulta conversacional, gestión de fuentes y análisis de datos. La API debe implementar autenticación segura, versionado, manejo de errores consistente y documentación interactiva." \
"api,integración,$READY_LABELS" "Ready"

create_issue "[DB-01] Configurar cluster de base de datos vectorial distribuida" \
"Implementar y configurar un cluster de base de datos optimizado para búsquedas vectoriales y semánticas. Incluye la configuración de nodos, definición de políticas de replicación y sharding, configuración de backups automatizados y optimización para consultas de similitud. Asegurar que la configuración permite escalabilidad horizontal." \
"database,infraestructura,$READY_LABELS" "Ready"

create_issue "[BUG-01] Fallo en extracción de contenido dinámico específico" \
"El extractor no logra capturar correctamente contenido que se carga mediante llamadas AJAX específicas en sitios que utilizan encriptación de payload. Reproducible consistentemente en 3 fuentes importantes. Prioridad: Alta." \
"bug,extracción,prioridad-alta,$READY_LABELS" "Ready"

echo -e "\n${BLUE}========== CREANDO ISSUES PARA IN PROGRESS ==========${NC}"

create_issue "[SCR-01] Implementar sistema de extracción para fuentes web dinámicas" \
"Desarrollar un componente robusto capaz de extraer información de sitios web con carga dinámica de contenido (JavaScript, AJAX). El sistema debe ser configurable para diferentes tipos de sitios, resistente a cambios en la estructura del DOM y capaz de manejar autenticación y sesiones cuando sea necesario. Incluir mecanismos para evitar la detección como bot." \
"extracción,desarrollo,$IN_PROGRESS_LABELS" "In Progress"

create_issue "[DIS-03] Diseñar interfaz de usuario conversacional" \
"Crear mockups y especificaciones para la interfaz de usuario del chatbot. Debe ser intuitiva, responsiva y accesible. Incluir flujos de conversación, manejo de errores, opciones de refinamiento de consultas y visualización de fuentes. Considerar tanto interfaces web como posibles integraciones con plataformas de mensajería." \
"diseño,ui,chatbot,$IN_PROGRESS_LABELS" "In Progress"

create_issue "[CHAT-01] Implementar motor de procesamiento de lenguaje natural" \
"Desarrollar un componente que analice las consultas en lenguaje natural, identifique la intención del usuario, extraiga entidades relevantes y determine el tipo de información requerida. Debe manejar consultas ambiguas, detectar preguntas de seguimiento y soportar diferentes patrones de pregunta." \
"chatbot,nlp,desarrollo,$IN_PROGRESS_LABELS" "In Progress"

create_issue "[BUG-03] Degradación de rendimiento en cluster tras 72h de operación" \
"Se observa un incremento gradual en la latencia de respuesta del cluster de base de datos después de aproximadamente 72 horas de operación continua. El análisis preliminar sugiere problemas con la gestión de memoria o fragmentación. Requiere reinicio programado del cluster para resolver temporalmente. Prioridad: Alta." \
"bug,database,rendimiento,prioridad-alta,$IN_PROGRESS_LABELS" "In Progress"

echo -e "\n${BLUE}========== CREANDO ISSUES PARA IN REVIEW ==========${NC}"

create_issue "[DB-02] Desarrollar pipeline de procesamiento y enriquecimiento de datos" \
"Crear un sistema de procesamiento que transforme los datos extraídos en un formato optimizado para su almacenamiento y consulta. Debe incluir etapas de limpieza, normalización, extracción de entidades, generación de embeddings vectoriales y metadatos relevantes. El pipeline debe ser extensible para incorporar nuevos tipos de procesamiento." \
"database,pipeline,$IN_REVIEW_LABELS" "In Review"

create_issue "[SCR-03] Implementar sistema de adaptación a cambios estructurales" \
"Desarrollar un componente inteligente que detecte automáticamente cambios en la estructura de las fuentes web y adapte los extractores en consecuencia. El sistema debe identificar patrones alternativos para localizar la misma información cuando la estructura original cambia, notificar cuando requiera intervención manual y mantener un registro de cambios detectados." \
"extracción,adaptación,$IN_REVIEW_LABELS" "In Review"

create_issue "[OPT-01] Optimización de rendimiento del cluster de base de datos" \
"Análisis completo y optimización del rendimiento del cluster. Incluye ajuste de configuración, optimización de índices, mejora de estrategias de particionamiento y refinamiento de consultas frecuentes. El objetivo es reducir la latencia media en un 40% y aumentar el throughput en situaciones de alta carga." \
"optimización,database,rendimiento,$IN_REVIEW_LABELS" "In Review"

create_issue "[DOC-01] Crear documentación técnica completa" \
"Elaborar documentación técnica detallada que cubra la arquitectura del sistema, decisiones de diseño, configuración de componentes y procedimientos de mantenimiento. Debe incluir diagramas, ejemplos de código y guías para extender el sistema. El objetivo es facilitar la transferencia de conocimiento y el mantenimiento futuro." \
"documentación,$IN_REVIEW_LABELS" "In Review"

echo -e "\n${BLUE}========== CREANDO ISSUES PARA DONE ==========${NC}"

create_issue "[INF-01] Configuración de infraestructura base" \
"Se ha completado la configuración de la infraestructura base para el desarrollo y despliegue del sistema. Incluye repositorio Git, entornos de desarrollo, staging y producción, así como la configuración inicial de servidores y servicios necesarios. La documentación de acceso y configuración está disponible en el wiki del proyecto." \
"infraestructura,$DONE_LABELS" "Done"

create_issue "[DIS-04] Investigación y selección de fuentes de datos" \
"Finalizado el análisis de fuentes de datos relevantes para el cliente. Incluye evaluación de 23 sitios web, 5 feeds de noticias y 3 APIs públicas. Se ha documentado la estructura de cada fuente, frecuencia de actualización, relevancia para el negocio y complejidad técnica de extracción. El informe incluye recomendaciones priorizadas." \
"diseño,investigación,$DONE_LABELS" "Done"

create_issue "[DB-03] Optimizar estrategias de búsqueda semántica" \
"Refinar los algoritmos de búsqueda semántica para mejorar la relevancia de los resultados. Implementar técnicas avanzadas como reranking, expansión de consultas y ponderación de campos. Optimizar parámetros como dimensionalidad de vectores, algoritmos de similaridad y umbral de relevancia basados en consultas representativas." \
"database,optimización,$DONE_LABELS" "Done"

create_issue "[CHAT-03] Desarrollar sistema de memoria conversacional" \
"Implementar un mecanismo que mantenga el contexto a lo largo de una conversación, permitiendo referencias implícitas a consultas anteriores. El sistema debe identificar entidades mencionadas previamente, mantener el tema de conversación y detectar cambios de contexto. Incluir capacidad de clarificación cuando sea necesario." \
"chatbot,memoria,$DONE_LABELS" "Done"

create_issue "[OPT-02] Mejorar calidad y relevancia de respuestas" \
"Refinamiento del sistema de generación de respuestas para aumentar su precisión, relevancia y naturalidad. Incluye implementación de mecanismos de verificación de hechos, detección de contradicciones entre fuentes y mejora de la síntesis de información. Debe evaluarse con un conjunto diverso de consultas representativas." \
"optimización,chatbot,$DONE_LABELS" "Done"

echo -e "\n${GREEN}¡Todas las issues han sido creadas exitosamente!${NC}"
echo -e "\n${YELLOW}INSTRUCCIONES PARA AÑADIR AL PROYECTO:${NC}"
echo -e "1. Ve a tu proyecto: $PROJECT_URL"
echo -e "2. Haz clic en '+ Add items'"
echo -e "3. Selecciona las issues que acabas de crear"
echo -e "4. Mueve cada issue a la columna apropiada según su etiqueta:"
echo -e "   - Issues con etiqueta '$BACKLOG_LABELS' → columna Backlog"
echo -e "   - Issues con etiqueta '$READY_LABELS' → columna Ready"
echo -e "   - Issues con etiqueta '$IN_PROGRESS_LABELS' → columna In Progress"
echo -e "   - Issues con etiqueta '$IN_REVIEW_LABELS' → columna In Review"
echo -e "   - Issues con etiqueta '$DONE_LABELS' → columna Done"