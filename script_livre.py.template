import os
import pandas as pd
from google import genai # Nouveau package
from odf import text, teletype
from odf.opendocument import load
import time

# ==========================================
# CONFIGURATION
# ==========================================
API_KEY = "..."
TXT_DIR = "txt"
OUTPUT_DIR = "generated_md"
CSV_METADATA = "liste_histoires.csv"

# MODE TEST : Mettez à True pour ne traiter que le premier fichier du CSV
MODE_TEST = False

# Initialisation du nouveau client Google GenAI
client = genai.Client(api_key=API_KEY)
MODEL_ID = "gemini-2.5-flash" # Ou gemini-2.0 si disponible en 2026 !

def read_txt(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return f.read()
    except Exception as e:
        return f"Erreur de lecture TXT : {e}"

def process_story(raw_text, title, subtitle, illustration):
    st_line = f'subtitle: "{subtitle}"' if pd.notna(subtitle) and subtitle != "" else ""
    ill_line = f'illustration: "{illustration}"' if pd.notna(illustration) and illustration != "" else ""

    prompt = f"""
Tu es un éditeur littéraire chevronné. Ta mission est de transformer ce récit familial en un texte fluide, élégant et prêt pour l'impression, tout en respectant scrupuleusement l'âme et le style de l'auteur original.

### RÈGLES DE RÉDACTION ET ÉDITION :
1. **CONSERVATION** : Garde le ton et la "voix" originale de l'auteur. Ne réécris pas pour faire "moderne".
2. **CORRECTIONS AUTORISÉES** : Corrige les fautes d'orthographe, de grammaire, de typographie, d'accords, et de ponctuation. Ajuste éventuellement la ponctuation si cela améliore objectivement le souffle et la lisibilité (virgules, points-virgules) sans dénaturer le phrasé de l'auteur.
3. **CORRECTIONS INTERDITES** : Réécriture stylistique, résumé, ajout d'explications, changement de scructure.
4. **TEMPS** : Conserve le temps de l'histoire. Ne corrige que les incohérences de temps au sein d'un même récit. Préfère le présent si le texte est hésitant entre deux temps.
5. **NOMBRES ET UNITÉS** : Convertis systématiquement les nombres narratifs en toutes lettres (ex : "trois kilomètres"), exceptions : dates, mesures techniques.
6. **TYPOGRAPHIE FRANÇAISE** :
   - Utilise l'apostrophe typographique courbe (’) exclusivement.
   - Utilise des espaces insécables (NBSP) avant : ; ? ! » et après «.
7. **DIALOGUES** : Respecte la typographie des dialogues à la française :
   - Commence le bloc de dialogue par « et finis-le par ».
   - Pour les changements de locuteurs à l'intérieur, utilise le tiret cadratin (—) suivi d'une espace insécable.
8. **PATOIS** : Mets les mots de patois en italique (*mot*). Si une traduction suit, mets-la entre parenthèses.
9. **INTÉGRALITÉ** : Il est impératif de traiter le texte jusqu'au dernier mot. Ne résume pas et ne coupe pas la fin.

### FORMAT DE SORTIE :
Produis un fichier Markdown commençant par ce bloc YAML, ne l'entoure pas de balises de code (triple backticks ```) :

---
title: "{title}"
{st_line}
{ill_line}
---

TEXTE À TRAITER :
{raw_text}
"""
    # Nouvelle syntaxe d'appel 2026
    response = client.models.generate_content(
        model=MODEL_ID,
        contents=prompt
    )
    return response.text

# ==========================================
# LANCEMENT
# ==========================================
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

try:
    # sep=None détecte automatiquement virgule ou point-virgule
    df = pd.read_csv(CSV_METADATA, sep=None, engine='python')
except Exception as e:
    print(f"Erreur lecture CSV : {e}")
    exit()

items_to_process = df.head(1).iterrows() if MODE_TEST else df.iterrows()

print(f"🚀 Démarrage (Mode Test: {MODE_TEST}) sur Python {os.sys.version.split()[0]}...")

for index, row in items_to_process:
    # On s'assure que les noms de colonnes correspondent à ton CSV
    filename = row['filename']
    output_file = os.path.join(OUTPUT_DIR, f"{filename}.md")

    if os.path.exists(output_file):
        # On passe à l'histoire suivante si le fichier MD existe déjà
        print(f"⚠️ Fichier .md existe déjà (skip) : {output_file}")
        continue

    title = row['title']
    subtitle = row.get('subtitle', "")
    illustration = row.get('illustration', "")

    txt_path = os.path.join(TXT_DIR, f"{filename}.txt")

    if os.path.exists(txt_path):
        print(f"📖 Traitement de : {filename}.txt...")
        raw_content = read_txt(txt_path)

        try:
            final_md = process_story(raw_content, title, subtitle, illustration)

            with open(output_file, "w", encoding="utf-8") as f:
                f.write(final_md)

            print(f"✅ Fichier généré : {output_file}")
            time.sleep(1) # Respect des quotas

        except Exception as e:
            if "429" in str(e):
                print("⏳ Quota atteint.")
                break
            else:
                print(f"❌ Erreur API pour {filename} : {e}")
                continue
    else:
        print(f"⚠️ Fichier .txt non trouvé : {txt_path}")

print("\n✨ Travail terminé !")
