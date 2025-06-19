"use client"

import { useState, useEffect } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover"
import { Calendar } from "@/components/ui/calendar"
import { CalendarIcon, FilterIcon, SearchIcon, XIcon } from "lucide-react"
import { format } from "date-fns"
import { vi } from "date-fns/locale"

export interface FilterOption {
  key: string
  label: string
  type: 'select' | 'text' | 'date' | 'daterange' | 'multiselect'
  options?: { value: string; label: string }[]
  placeholder?: string
}

export interface SearchFilterProps {
  searchPlaceholder?: string
  filterOptions?: FilterOption[]
  onSearch: (query: string, filters: Record<string, any>) => void
  className?: string
}

export default function SearchFilter({ 
  searchPlaceholder = "Tìm kiếm...",
  filterOptions = [],
  onSearch,
  className = ""
}: SearchFilterProps) {
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [showFilters, setShowFilters] = useState(false)
  const [activeFiltersCount, setActiveFiltersCount] = useState(0)

  useEffect(() => {
    // Đếm số lượng filter đang được áp dụng
    const count = Object.values(filters).filter(value => {
      if (Array.isArray(value)) return value.length > 0
      return value !== undefined && value !== '' && value !== null
    }).length
    setActiveFiltersCount(count)
  }, [filters])

  useEffect(() => {
    // Debounce search
    const timer = setTimeout(() => {
      onSearch(searchQuery, filters)
    }, 300)

    return () => clearTimeout(timer)
  }, [searchQuery, filters, onSearch])

  const handleFilterChange = (key: string, value: any) => {
    setFilters(prev => ({
      ...prev,
      [key]: value
    }))
  }

  const clearFilter = (key: string) => {
    setFilters(prev => {
      const newFilters = { ...prev }
      delete newFilters[key]
      return newFilters
    })
  }

  const clearAllFilters = () => {
    setFilters({})
    setSearchQuery("")
  }

  const renderFilterInput = (option: FilterOption) => {
    const value = filters[option.key]

    switch (option.type) {
      case 'select':
        return (
          <Select
            value={value || "all"}
            onValueChange={(val) => handleFilterChange(option.key, val === "all" ? "" : val)}
          >
            <SelectTrigger>
              <SelectValue placeholder={option.placeholder || `Chọn ${option.label.toLowerCase()}`} />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Tất cả</SelectItem>
              {option.options?.map((opt) => (
                <SelectItem key={opt.value} value={opt.value}>
                  {opt.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        )

      case 'multiselect':
        return (
          <Select
            value={Array.isArray(value) ? value.join(',') : ''}
            onValueChange={(val) => {
              const values = val ? val.split(',') : []
              handleFilterChange(option.key, values)
            }}
          >
            <SelectTrigger>
              <SelectValue placeholder={option.placeholder || `Chọn ${option.label.toLowerCase()}`} />
            </SelectTrigger>
            <SelectContent>
              {option.options?.map((opt) => (
                <SelectItem key={opt.value} value={opt.value}>
                  {opt.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        )

      case 'date':
        return (
          <Popover>
            <PopoverTrigger asChild>
              <Button
                variant="outline"
                className="w-full justify-start text-left font-normal"
              >
                <CalendarIcon className="mr-2 h-4 w-4" />
                {value ? format(new Date(value), "dd/MM/yyyy", { locale: vi }) : (option.placeholder || "Chọn ngày")}
              </Button>
            </PopoverTrigger>
            <PopoverContent className="w-auto p-0" align="start">
              <Calendar
                mode="single"
                selected={value ? new Date(value) : undefined}
                onSelect={(date) => handleFilterChange(option.key, date?.toISOString())}
                initialFocus
              />
            </PopoverContent>
          </Popover>
        )

      case 'daterange':
        const [startDate, endDate] = Array.isArray(value) ? value : [null, null]
        return (
          <div className="grid grid-cols-2 gap-2">
            <Popover>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  className="justify-start text-left font-normal"
                >
                  <CalendarIcon className="mr-2 h-4 w-4" />
                  {startDate ? format(new Date(startDate), "dd/MM", { locale: vi }) : "Từ ngày"}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto p-0" align="start">
                <Calendar
                  mode="single"
                  selected={startDate ? new Date(startDate) : undefined}
                  onSelect={(date) => handleFilterChange(option.key, [date?.toISOString(), endDate])}
                  initialFocus
                />
              </PopoverContent>
            </Popover>
            <Popover>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  className="justify-start text-left font-normal"
                >
                  <CalendarIcon className="mr-2 h-4 w-4" />
                  {endDate ? format(new Date(endDate), "dd/MM", { locale: vi }) : "Đến ngày"}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto p-0" align="start">
                <Calendar
                  mode="single"
                  selected={endDate ? new Date(endDate) : undefined}
                  onSelect={(date) => handleFilterChange(option.key, [startDate, date?.toISOString()])}
                  initialFocus
                />
              </PopoverContent>
            </Popover>
          </div>
        )

      case 'text':
      default:
        return (
          <Input
            placeholder={option.placeholder || `Nhập ${option.label.toLowerCase()}`}
            value={value || ''}
            onChange={(e) => handleFilterChange(option.key, e.target.value)}
          />
        )
    }
  }

  const getActiveFilters = () => {
    return Object.entries(filters).filter(([key, value]) => {
      if (Array.isArray(value)) return value.length > 0
      return value !== undefined && value !== '' && value !== null
    })
  }

  return (
    <div className={`space-y-4 ${className}`}>
      {/* Search Bar */}
      <div className="flex flex-col sm:flex-row gap-2">
        <div className="relative flex-1 w-full">
          <SearchIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
          <Input
            placeholder={searchPlaceholder}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10"
          />
        </div>
        <Button
          variant="outline"
          onClick={() => setShowFilters(!showFilters)}
          className="flex items-center gap-2 w-full sm:w-auto"
        >
          <FilterIcon className="h-4 w-4" />
          Lọc
          {activeFiltersCount > 0 && (
            <Badge variant="secondary" className="ml-1">
              {activeFiltersCount}
            </Badge>
          )}
        </Button>
        {(activeFiltersCount > 0 || searchQuery) && (
          <Button
            variant="ghost"
            onClick={clearAllFilters}
            className="flex items-center gap-2 w-full sm:w-auto mt-2 sm:mt-0"
          >
            <XIcon className="h-4 w-4" />
            Xóa tất cả
          </Button>
        )}
      </div>

      {/* Active Filters Tags */}
      {getActiveFilters().length > 0 && (
        <div className="flex flex-wrap gap-2">
          {searchQuery && (
            <Badge variant="secondary" className="flex items-center gap-1">
              Tìm kiếm: "{searchQuery}"
              <XIcon 
                className="h-3 w-3 cursor-pointer" 
                onClick={() => setSearchQuery("")}
              />
            </Badge>
          )}
          {getActiveFilters().map(([key, value]) => {
            const option = filterOptions.find(opt => opt.key === key)
            if (!option) return null

            let displayValue = value
            if (Array.isArray(value)) {
              if (option.type === 'daterange') {
                const [start, end] = value
                displayValue = `${start ? format(new Date(start), "dd/MM", { locale: vi }) : ''} - ${end ? format(new Date(end), "dd/MM", { locale: vi }) : ''}`
              } else {
                displayValue = value.join(', ')
              }
            } else if (option.type === 'date') {
              displayValue = format(new Date(value), "dd/MM/yyyy", { locale: vi })
            } else if (option.type === 'select' && option.options) {
              const selectedOption = option.options.find(opt => opt.value === value)
              displayValue = selectedOption?.label || value
            }

            return (
              <Badge key={key} variant="secondary" className="flex items-center gap-1">
                {option.label}: {displayValue}
                <XIcon 
                  className="h-3 w-3 cursor-pointer" 
                  onClick={() => clearFilter(key)}
                />
              </Badge>
            )
          })}
        </div>
      )}

      {/* Filter Panel */}
      {showFilters && filterOptions.length > 0 && (
        <div className="border rounded-lg p-4 bg-muted/30">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filterOptions.map((option) => (
              <div key={option.key} className="space-y-2">
                <label className="text-sm font-medium">
                  {option.label}
                </label>
                {renderFilterInput(option)}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
} 