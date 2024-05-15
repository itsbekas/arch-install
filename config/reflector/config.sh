# Configures reflector.conf
# Receives the file path as an argument

# Sets the number of threads to the number of processors
sed -i "s/N_THREADS/$(nproc)/" $1
