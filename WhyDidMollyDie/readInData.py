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
# %%
colDictionary = {'Total Value': float,
                 'Natural Value': float}
# %%
MollyRun = MollyRun.astype(colDictionary)
# %%
print('Hello World')
# %%
