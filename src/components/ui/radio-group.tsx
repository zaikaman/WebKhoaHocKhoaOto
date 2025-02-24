import React from 'react';

interface RadioGroupProps {
  children: React.ReactNode;
  name: string;
  defaultValue?: string;
}

export const RadioGroup = ({ children, name, defaultValue }: RadioGroupProps) => {
  return <div className="flex flex-col" role="group" aria-labelledby={name}>{children}</div>;
};

interface RadioGroupItemProps {
  value: string;
  id: string;
}

export const RadioGroupItem = ({ value, id }: RadioGroupItemProps) => {
  return (
    <input type="radio" value={value} id={id} className="mr-2" />
  );
}; 