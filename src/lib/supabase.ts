import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://lrnlbvdgqpazzwbsxhqc.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxybmxidmRncXBhenp3YnN4aHFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk1NDQ2NDYsImV4cCI6MjA1NTEyMDY0Nn0.dQwqFBrx2JApXKwBPrBRgnrwElliv4gmkVlAtkV5f5Y'

export const supabase = createClient(supabaseUrl, supabaseKey) 