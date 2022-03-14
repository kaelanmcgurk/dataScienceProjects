#%%
import pandas as pd
import altair as alt

# %%
basketballData = pd.read_csv('cbb.csv')
basketballData20 = pd.read_csv('cbb20.csv')
basketballData21 = pd.read_csv('cbb21.csv')
# %%
basketballData21['YEAR'] = 2021
basketballData20['YEAR'] = 2020

# %%
frames = [basketballData, basketballData20, basketballData21]

basketball_college = pd.concat(frames)
basketball_college.to_csv(r"C:\Users\kaela\Documents\dataScienceProjects\dataScienceProjects\MarchMadness2022\basketball.csv")
# %%
