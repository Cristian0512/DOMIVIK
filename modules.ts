export type ModuleKey='produse'|'bonuri'|'facturi'|'finante'|'rate'|'garaj'|'proiecte'|'calendar'|'familie';
export const modules: {key:ModuleKey;title:string;icon:string;description:string}[]=[
{key:'produse',title:'Produsele mele',icon:'cube-outline',description:'Produse, fotografii, garanții, documente'},
{key:'bonuri',title:'Bonuri',icon:'receipt-outline',description:'Bonuri scanate, articole, istoric prețuri'},
{key:'facturi',title:'Facturi și utilități',icon:'document-text-outline',description:'Facturi, dovezi, contoare și scadențe'},
{key:'finante',title:'Finanțe',icon:'wallet-outline',description:'Venituri, cheltuieli, bugete și rapoarte'},
{key:'rate',title:'Rate și credite',icon:'card-outline',description:'Casă, mașină, credite și rambursări'},
{key:'garaj',title:'Garaj',icon:'car-outline',description:'Vehicule, ITP, RCA, alimentări și service'},
{key:'proiecte',title:'Proiecte',icon:'hammer-outline',description:'Lucrări, bugete, fotografii și progres'},
{key:'calendar',title:'Calendar',icon:'calendar-outline',description:'Scadențe, garanții și notificări'},
{key:'familie',title:'Familie',icon:'people-outline',description:'Membri, invitații și permisiuni'}];
