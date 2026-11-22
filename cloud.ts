import {createClient} from '@supabase/supabase-js';
const url=process.env.EXPO_PUBLIC_SUPABASE_URL;
const key=process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;
export const cloudConfigured=Boolean(url&&key);
export const supabase=cloudConfigured?createClient(url!,key!,{auth:{autoRefreshToken:true,persistSession:false,detectSessionInUrl:false}}):null;
// IMPORTANT: persistSession:false is temporary for the prototype. Before production,
// configure secure session persistence using an appropriate native storage adapter.
// Never put a service_role key in EXPO_PUBLIC_* variables.
