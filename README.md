# Examen Práctico Final — Seguridad Informática

**Estudiante:** Gldys Rosaura Yana Pari 
**Repositorio sugerido:** `examen-practico-yana`  
**Curso:** Seguridad Informática  
**Unidad IV:** Monitoreo de Seguridad, SIEM e Inteligencia Artificial  
**Modalidad elegida:** AWS Education / AWS Educate por recursos limitados en PC local.

## 1. Arquitectura elegida: una sola instancia EC2

Para simplificar la ejecución y ahorrar créditos de AWS, todos los laboratorios se ejecutan en una sola instancia EC2.

| Recurso | Valor a completar |
|---|---|
| Región | `us-east-1` |
| AMI | Ubuntu Server 22.04 LTS o Ubuntu 24.04 LTS |
| Tipo de instancia | `t3.large` recomendado |
| Disco | 60 GB recomendado |
| ID de instancia | `i-xxxxxxxxxxxxxxxxx` |
| IP pública | `x.x.x.x` |
| Hostname | `ip-172-31-xx-xx` |

Justificación: la evaluación requiere Wazuh, Wazuh Dashboard, Jupyter Notebook y librerías de Machine Learning. Por ello, se usa una instancia EC2 para garantizar recursos suficientes y evitar limitaciones del equipo local.

## 2. Security Group recomendado

| Puerto | Servicio | Origen recomendado |
|---|---|---|
| 22 | SSH | My IP |
| 443 | Wazuh Dashboard | My IP |
| 8888 | Jupyter Notebook | My IP |

No se recomienda dejar puertos abiertos a `0.0.0.0/0`, salvo prueba temporal.

## 3. Preparación inicial

```bash
cd ~
git clone https://github.com/USUARIO/examen-practico-yana.git
cd examen-practico-yana
chmod +x scripts/*.sh
./scripts/preparar_una_instancia.sh
```

Si el script de descarga falla, ejecutar nuevamente:

```bash
./scripts/descargar_datos.sh
```

Verificar datos:

```bash
ls -lh lab1/auth.log lab1/access.log lab3/network_traffic.csv
```

---

# Laboratorio 1 — Análisis Forense de Logs con Python

Activar entorno:

```bash
cd ~/examen-practico-yana
source .venv/bin/activate
```

Ejecutar análisis SSH:

```bash
python lab1/analizar_ssh.py
cat lab1/reporte_ssh.json
```

Ejecutar análisis web:

```bash
python lab1/analizar_web.py
cat lab1/reporte_web.json
```

Generar gráficas:

```bash
python lab1/visualizar.py
ls -lh lab1/graficas/
```

Evidencias:

```text
lab1/evidencias/SCR-1.1a_ssh_ejecucion.png
lab1/evidencias/SCR-1.1b_ssh_json.png
lab1/evidencias/SCR-1.2a_web_ejecucion.png
lab1/evidencias/SCR-1.2b_web_json.png
```

Commit:

```bash
git add lab1/
git commit -m "finalizar laboratorio 1 analisis de logs"
git push
```

---

# Laboratorio 2 — Reglas de Correlación en Wazuh

## 2.1 Instalar Wazuh All-in-One

```bash
cd ~/examen-practico-yana
./scripts/instalar_wazuh_all_in_one.sh
```

Guardar la contraseña mostrada para el usuario `admin`.

Verificar servicios:

```bash
sudo systemctl status wazuh-manager --no-pager
sudo systemctl status wazuh-indexer --no-pager
sudo systemctl status wazuh-dashboard --no-pager
```

Evidencia:

```text
lab2/evidencias/SCR-2.1_wazuh_activo.png
```

## 2.2 Aplicar reglas locales

```bash
cd ~/examen-practico-yana
./scripts/aplicar_reglas_wazuh.sh
```

Validación manual:

```bash
xmllint --noout lab2/local_rules_ssh.xml && echo "local_rules_ssh.xml OK"
xmllint --noout lab2/local_rules_exfil.xml && echo "local_rules_exfil.xml OK"
```

Evidencia:

```text
lab2/evidencias/SCR-2.2_reglas_validadas.png
```

## 2.3 Simular fuerza bruta SSH

```bash
sudo bash lab2/simular_bruteforce.sh 203.0.113.60 15
sleep 10
sudo grep -nE "100001|Ataque de fuerza bruta|203.0.113.60" /var/ossec/logs/alerts/alerts.log | tail -n 80
```

Evidencia:

```text
lab2/evidencias/SCR-2.3_alerta_disparada.png
```

Commit:

```bash
git add lab2/
git commit -m "finalizar laboratorio 2 reglas wazuh"
git push
```

---

# Laboratorio 3 — Modelo de Detección de Anomalías con ML

Abrir Jupyter:

```bash
cd ~/examen-practico-yana
source .venv/bin/activate
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser
```

En AWS abrir temporalmente:

```text
TCP 8888 -> My IP
```

Entrar desde navegador:

```text
http://IP_PUBLICA:8888
```

Ejecutar completo:

```text
lab3/deteccion_anomalias.ipynb
```

Probar predicción:

```bash
python lab3/predecir.py lab3/nuevo_trafico.csv
```

Verificar modelo:

```bash
ls -lh lab3/modelo_anomalias.pkl
```

Evidencias:

```text
lab3/evidencias/SCR-3.1_eda.png
lab3/evidencias/SCR-3.2_metricas.png
lab3/evidencias/SCR-3.3_umbral_f1.png
lab3/evidencias/SCR-3.4_predecir.png
```

Cerrar Jupyter al terminar para liberar RAM:

```bash
pkill -f jupyter
```

Commit:

```bash
git add lab3/
git commit -m "finalizar laboratorio 3 deteccion de anomalias"
git push
```

---

# Laboratorio 4 — Dashboard SOC en Wazuh

Entrar al dashboard:

```text
https://IP_PUBLICA
```

Usuario: `admin`.

Para recuperar contraseña:

```bash
sudo find / -name "wazuh-install-files.tar" 2>/dev/null
sudo tar -O -xvf /home/ubuntu/wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt | grep -A 1 "admin"
```

Ver fuente de datos:

```text
Dashboard Management → Index patterns → wazuh-alerts-*
```

Evidencia:

```text
lab4/evidencias/SCR-4.1_fuente_datos.png
```

Crear visualizaciones:

```text
V1 - Alertas por nivel de severidad
Tipo: Vertical bar
Data view: wazuh-alerts-*
Métrica: Count
Campo: rule.level

V2 - Top 10 IPs con más alertas
Tipo: Data table
Data view: wazuh-alerts-*
Métrica: Count
Campo: data.srcip o data.srcip.keyword

V3 - Alertas por hora
Tipo: Line
Data view: wazuh-alerts-*
Métrica: Count
Campo tiempo: timestamp
Intervalo: 1 hour

V4 - Distribución por tipo de regla
Tipo: Pie
Data view: wazuh-alerts-*
Métrica: Count
Campo: rule.groups o rule.description.keyword
```

Evidencia:

```text
lab4/evidencias/SCR-4.2_visualizaciones.png
```

Crear dashboard final:

```text
Nombre: SOC - Monitor de Seguridad
Rango: Last 24 hours
Panel de texto con nombre de la estudiante, curso, instancia e IP pública.
```

Evidencia:

```text
lab4/evidencias/SCR-4.3_dashboard.png
```

Alerta de umbral:

```text
Alerting / Monitors
Nombre: Alerta - Severidad alta SOC
Índice: wazuh-alerts-*
Condición: rule.level >= 10
Umbral: más de 5 eventos en 5 minutos
```

Evidencia:

```text
lab4/evidencias/SCR-4.4_alerta.png
```

Commit:

```bash
git add lab4/
git commit -m "finalizar laboratorio 4 dashboard soc"
git push
```

---

# Checklist final

```bash
git status
find lab1 lab2 lab3 lab4 -maxdepth 3 -type f | sort
```

Debe existir:

```text
lab1/reporte_ssh.json
lab1/reporte_web.json
lab1/graficas/top10_ssh.png
lab1/graficas/timeline_http.png
lab1/graficas/heatmap_http.png
lab2/local_rules_ssh.xml
lab2/local_rules_exfil.xml
lab3/modelo_anomalias.pkl
lab4/dashboard_soc.json
capturas en carpetas evidencias/
```

Push final:

```bash
git add .
git commit -m "entrega final examen practico seguridad informatica" || true
git push
```
