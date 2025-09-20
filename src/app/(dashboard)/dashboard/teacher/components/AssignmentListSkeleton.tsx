import { Skeleton } from "@/components/ui/skeleton";

export function AssignmentListSkeleton() {
  const SkeletonGroup = () => (
    <div className="p-4">
      <div className="flex flex-col sm:flex-row items-start sm:items-center gap-4">
        <Skeleton className="h-10 w-10 rounded-full flex-shrink-0" />
        <div className="flex-1 w-full space-y-2">
          <Skeleton className="h-6 w-3/4" />
          <Skeleton className="h-4 w-1/4" />
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mt-2">
            <div className="space-y-1">
              <Skeleton className="h-4 w-2/3" />
              <Skeleton className="h-4 w-1/2" />
            </div>
            <div className="space-y-1">
              <Skeleton className="h-4 w-2/3" />
              <Skeleton className="h-4 w-1/2" />
            </div>
            <div className="space-y-1">
              <Skeleton className="h-4 w-2/3" />
              <Skeleton className="h-4 w-1/2" />
            </div>
          </div>
        </div>
        <Skeleton className="h-9 w-24 rounded-md" />
      </div>
    </div>
  );

  return (
    <div className="space-y-8">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 sm:gap-0">
            <div>
                <Skeleton className="h-8 w-32" />
                <Skeleton className="h-4 w-48 mt-2" />
            </div>
            <div className="flex items-center gap-2">
                <Skeleton className="h-9 w-24" />
                <Skeleton className="h-9 w-32" />
            </div>
        </div>
        <div className="rounded-md border">
            <div className="divide-y">
                <SkeletonGroup />
                <SkeletonGroup />
                <SkeletonGroup />
                <SkeletonGroup />
            </div>
        </div>
    </div>
  );
}
