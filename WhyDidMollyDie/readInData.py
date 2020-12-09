#%%
import pandas as pd
import altair as alt
import os
# %%
dat = pd.read_csv('AllRollsWildemount.csv')
# %%
MollyRun = dat.query("Episode == 'C2E001' | Episode == 'C2E002'| Episode == 'C2E003'| Episode == 'C2E004'| Episode == 'C2E005'| Episode == 'C2E006'| Episode == 'C2E007'| Episode == 'C2E008'| Episode == 'C2E009'| Episode == 'C2E010'| Episode == 'C2E011'| Episode == 'C2E012'| Episode == 'C2E013'| Episode == 'C2E014'| Episode == 'C2E015'| Episode == 'C2E016'| Episode == 'C2E017'| Episode == 'C2E018'| Episode == 'C2E019'| Episode == '20-Feb'| Episode == '21-Feb'| Episode == '22-Feb'| Episode == '23-Feb'| Episode == '24-Feb'| Episode == '25-Feb'| Episode == '26-Feb'")
# %%
MollyRun = MollyRun.replace('Nat20',20)
MollyRun = MollyRun.replace('Nat1',1)
MollyRun = MollyRun.replace('Unknown',0)
MollyRun = MollyRun.replace('Nat6',6)
MollyRun = MollyRun.replace('Nat5',5)
MollyRun = MollyRun.replace('Nat13',13)
MollyRun = MollyRun.replace('Nat14',14)
MollyRun = MollyRun.replace('Nat4',4)
MollyRun = MollyRun.replace('Nat8',8)
MollyRun = MollyRun.replace('20-Feb','C2E020')
MollyRun = MollyRun.replace('21-Feb','C2E021')
MollyRun = MollyRun.replace('22-Feb','C2E022')
MollyRun = MollyRun.replace('23-Feb','C2E023')
MollyRun = MollyRun.replace('24-Feb','C2E024')
MollyRun = MollyRun.replace('25-Feb','C2E025')
MollyRun = MollyRun.replace('26-Feb','C2E026')
# %%
colDictionary = {'Total Value': float,
                 'Natural Value': float}
# %%
MollyRun = MollyRun.astype(colDictionary)
# %%
MollyRun = (MollyRun
.rename(columns = {"Total Value": "TotalValue",
"Natural Value": "NaturalValue",
"Damage Dealt": "DamageDealt",
"Type of Roll": "TypeOfRoll"}))

# %%
MollyRun = MollyRun.assign(DamageDealt = lambda x: x['DamageDealt'].str.extract('(\d+)'))


# %%
MollyRun = MollyRun.astype({'DamageDealt':float})
# %%
# Create the bar chart for damage output
CharacterDamage = MollyRun.query("TypeOfRoll == 'Damage'")
# %%
